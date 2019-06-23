FROM alpine:3.10

ENV SSH_PORT=22

ENV SSH_PUB_KEY=""
ENV SSH_KEY_SEPARATOR=","

RUN apk add --update --no-cache openssh && \
    sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config && \
    sed -i s/AllowTcpForwarding.*/AllowTcpForwarding\ yes/ /etc/ssh/sshd_config && \
    sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh 

COPY fs/ /

RUN chmod +x /run.sh

CMD [ "/run.sh" ]