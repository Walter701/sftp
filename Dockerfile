FROM alpine

# shadow is required for usermod
# tzdata for time syncing
# bash for entrypoint script
RUN apk add --no-cache openssh bash shadow tzdata

# Ensure key creation
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# Create entrypoint script
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN mkdir -p /docker-entrypoint.d

# SSH Server configuration file
ADD sshd_config /etc/ssh/sshd_config
RUN addgroup sftp
RUN mkdir /sftp
RUN useradd -m sftpdevelop -g sftp -d /sftp/sftpdevelop
RUN echo "sftpdevelop:1q2w3e4r" | chpasswd

# Default environment variables
ENV TZ="America/Buenos_Aires" \
    LANG="C.UTF-8" \
    FOLDER="/sftp" 

EXPOSE 2222
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# RUN SSH in no daemon and expose errors to stdout
#CMD [ "/usr/sbin/sshd", "-D", "-e" ]
CMD [ "/bin/bash", "-D", "-e" ]
