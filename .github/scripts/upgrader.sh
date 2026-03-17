#!/bin/bash

# Configuration
GITHUB_API="https://api.github.com"
DOCKER_REGISTRY_API="https://hub.docker.com/v2/repositories"
# Use your custom env var or fallback to GITHUB_TOKEN (for the CI)
GH_TOKEN="${LOCAL_UPGRADE_HOMEASSISTANT_APPS_TOKEN:-$GH_TOKEN}"

# Function to fetch the latest tag from Docker Hub using pagination
get_latest_docker_tag() {
  local image=$1
  local regex=$2
  local page=1
  local found_tag=""

  while [ "$page" -le 10 ]; do
    local response
    # Fetch tags ordered by last_updated to get newest ones first
    response=$(curl -s "${DOCKER_REGISTRY_API}/${image}/tags?page=${page}&page_size=100&ordering=last_updated")

    # Check if we have results
    if [[ "$(echo "$response" | jq -r '.results')" == "null" ]] || [[ "$(echo "$response" | jq -r '.results | length')" -eq 0 ]]; then
      break
    fi

    # Get the first tag that matches the regex (most recent updated)
    found_tag=$(echo "$response" | jq -r '.results[].name' | grep -E -m 1 "$regex")

    [ -n "$found_tag" ] && echo "$found_tag" && return

    ((page++))
  done
  echo "null"
}

# Function to fetch latest GitHub Release
get_latest_gh_release() {
  local repo=$1
  # Uses the /releases/latest endpoint to get the newest stable release
  curl -s -H "Authorization: token $GH_TOKEN" \
       "${GITHUB_API}/repos/${repo}/releases/latest" | jq -r '.tag_name // "null"'
}

for dir in */ ; do
  # Remove trailing slash for cleaner logs
  app=${dir%/}

  # Skip hidden directories like .git or .github
  [[ "$app" == .* ]] && continue

  [ ! -f "${app}/upgrade.yaml" ] && continue

  echo ">>> Processing: $app"

  SOURCE=$(yq '.upgrade_config.source' "${app}/upgrade.yaml")
  CURRENT_VERSION=$(yq '.upgrade_config.version' "$app/upgrade.yaml")
  NEW_VERSION="null"

  case "$SOURCE" in
    "github_releases")
      REPO=$(yq '.upgrade_config.repo' "${app}/upgrade.yaml")
      NEW_VERSION=$(get_latest_gh_release "$REPO")
      # For skopeo/metadata, use the repo as the image reference
      IMAGE_REF="$REPO"
      # Prefix for GitHub Container Registry if not present
      [[ "$IMAGE_REF" != ghcr.io/* ]] && FULL_IMAGE_REF="docker://ghcr.io/$IMAGE_REF" || FULL_IMAGE_REF="docker://$IMAGE_REF"
      ;;
    "docker_hub")
      IMAGE_REF=$(yq '.upgrade_config.image' "${app}/upgrade.yaml")
      REGEX=$(yq '.upgrade_config.tag_regex' "${app}/upgrade.yaml")
      NEW_VERSION=$(get_latest_docker_tag "$IMAGE_REF" "$REGEX")
      # Prefix for Docker Hub (library/ if it's a short name)
      [[ "$IMAGE_REF" != */* ]] && FULL_IMAGE_REF="docker://docker.io/library/$IMAGE_REF" || FULL_IMAGE_REF="docker://docker.io/$IMAGE_REF"
      ;;
    *)
      echo "Unknown source: $SOURCE"
      continue
      ;;
  esac

  if [ "$NEW_VERSION" != "null" ] && [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
    echo "Upgrade found for ${app}: $CURRENT_VERSION -> $NEW_VERSION"

    # 1. Update version in upgrade.yaml
    yq -i ".upgrade_config.version = \"$NEW_VERSION\"" "$app/upgrade.yaml"

    # 2. Update version in config.yaml
    yq -i ".version = \"$NEW_VERSION\"" "${app}/config.yaml"

    # 3. Update build.yaml
    if [ -f "${app}/build.yaml" ]; then
      # Update all versions in build_from list
      # This regex replaces the version after the last colon in any string under build_from
      yq -i '.build_from[] |= sub(":.*$", ":" + "'"$NEW_VERSION"'")' "$app/build.yaml"

      METADATA=$(skopeo inspect --config "$FULL_IMAGE_REF:$NEW_VERSION")

      if [ $? -eq 0 ]; then
        export EP_VAL=$(echo "$METADATA" | jq -c '.config.Entrypoint // [] | join(" ")')
        export CMD_VAL=$(echo "$METADATA" | jq -c '.config.Cmd // [] | join(" ")')

        yq -i '.args.ORIGINAL_ENTRYPOINT = env(EP_VAL) | .args.ORIGINAL_CMD = env(CMD_VAL)' "${app}/build.yaml"
      else
        echo "Error: Could not fetch metadata (via Skopeo) from $FULL_IMAGE_REF:$NEW_VERSION for $app"
      fi
    fi

    # 4. Update README.md release shield
    if [ -f "${app}/README.md" ]; then
      # The regex matches: https://img.shields.io/badge/version-[ANYTHING]-[ANY TEXT REPRESENTING COLOR].svg
      sed -i -E "s|\[release-shield\]: https://img\.shields\.io/badge/version-.*-([a-z]+)\.svg|[release-shield]: https://img.shields.io/badge/version-$NEW_VERSION-\1.svg|g" "${app}/README.md"
    fi
  else
    echo "  App ${app} is up to date."
  fi
done