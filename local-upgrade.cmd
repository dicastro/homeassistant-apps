@echo off

docker run --rm -it ^
  -v "%cd%":/work ^
  -w /work ^
  --env-file .env ^
  dicastro/homeassistant-apps-upgrader-tools ^
  ./.github/scripts/upgrader.sh