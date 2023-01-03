#!/bin/bash
set -e

FOLDER="/sftp"
USERNAME="sftpdevelop"
PASSWORD="1q2w3e4r"
echo $FOLDER

# Allow to run complementary processes or to enter the container without
# running this init script.
if [ "$1" == '/usr/sbin/sshd' ]; then

  useradd -m $USERNAME -g sftp -d $FOLDER/$USERNAME

  # Change sftp password
  echo "$USERNAME:$PASSWORD" | chpasswd

  # Mount the data folder in the chroot folder

  # Check if a script is available in /docker-entrypoint.d and source it
  # You can use it for example to create additional sftp users
  for f in /docker-entrypoint.d/*; do
    case "$f" in
      *.sh)  echo "$0: running $f"; . "$f" ;;
      *)     echo "$0: ignoring $f" ;;
    esac
  done

fi

exec "$@"


