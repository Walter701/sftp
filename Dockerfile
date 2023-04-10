FROM alpine

# shadow is required for usermod
# tzdata for time syncing
# bash for entrypoint script
RUN apk add --no-cache openssh bash shadow tzdata tcpdump openjdk11 unzip

# Ensure key creation
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# Create entrypoint script
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN mkdir -p /docker-entrypoint.d
RUN mkdir -p /data

# SSH Server configuration file
ADD sshd_config /etc/ssh/sshd_config
RUN addgroup sftp
RUN mkdir -p /aux/as2/config
ADD OpenAS2Server-3.5.0.zip /aux/as2
ADD as2-server /docker-entrypoint.d/
ADD config/ /aux/as2/config/
#RUN chmod +x /docker-entrypoint.d/as2-server.sh
#RUN unzip /home/as2/OpenAS2Server-3.5.0.zip -d /home/as2; exit 0
#; rm OpenAS2Server-3.5.0.zip
RUN useradd -m sftpdevelop -g sftp -d /data/sftpdevelop
RUN echo "sftpdevelop:1q2w3e4r" | chpasswd
RUN chmod 644 /etc/shadow

# Default environment variables
ENV TZ="America/Buenos_Aires" \
    LANG="C.UTF-8" \
    FOLDER="/sftp" 

EXPOSE 2222
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# RUN SSH in no daemon and expose errors to stdout
CMD [ "/usr/sbin/sshd", "-D", "-e" ]
#CMD ["/bin/bash", "-c", "--", "while true; do sleep 30; done;"]


