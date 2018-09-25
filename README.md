**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# mariadb-client
A small and secure Docker image of the Mariadb client, mysql (currently 10.3.9).

## Environment variables
### pre-set runtime variables
* VAR_FINAL_COMMAND="pause"
* VAR_LINUX_USER="mysql"

## Capabilities
Can drop all but CHOWN, DAC_OVERRIDE, FOWNER, SETGID and SETUID.

## Tips
Check also out huggla/mariadb-alpine and huggla/mariadb-backup.
