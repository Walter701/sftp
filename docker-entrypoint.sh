#!/bin/bash
set -e

# Allow to run complementary processes or to enter the container without
# running this init script.
if [ "$1" == '/usr/sbin/sshd' ]; then
  mkdir -p /sftp/etc/ssh
  if [ ! -f /sftp/etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -f /sftp/etc/ssh/ssh_host_rsa_key -N '' -t rsa
  fi
  if [ ! -f /sftp/etc/ssh/ssh_host_dsa_key ]; then
    ssh-keygen -f /sftp/etc/ssh/ssh_host_dsa_key -N '' -t dsa
  fi
  if [ ! -f /sftp/etc/ssh/ssh_host_ecdsa_key ]; then
    ssh-keygen -f /sftp/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
  fi
  cp /etc/ssh/sshd_config /sftp/etc/ssh/


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
