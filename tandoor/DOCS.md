# My Home Assistant App: Tandoor Recipes

## Installation

TBD

## Configuration

TBD

1. Login as 'root' at https://{{ subdomain }}.{{ cluster_domain }}/setup
2. Create a superuser account
3. Login as the superuser user and create a new recipe space
4. Go to 'Settings > Space Members > Invites > + NEW' and create a new invite for yourself
5. Copy the invite link
6. Logout as the superuser user
7. Access the invite link (without the final '/')
8. Fill the signup form
9. Use the 'non-superuser' user to manage recipes
10. Delete the 'tandoorrecipes' stack from portainer and run the next ansible playbook in order to have a running instance with signups disabled

https://docs.tandoor.dev/system/configuration