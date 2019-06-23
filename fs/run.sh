#!/usr/bin/env sh

if [[ -z "$SSH_PUB_KEY" ]]; then 
    echo -e "public key not found in SSH_PUB_KEY environment variable\n"
    exit 1
fi

# in case there are multiple keys
IFS=$","
for key in $SSH_PUB_KEY; do
    if [[ -n $key ]]; then
        echo "$key" >> ~/.ssh/authorized_keys
    fi
done
unset IFS

# enable custom port
sed -i s/#Port.*/Port\ ${SSH_PORT}/ /etc/ssh/sshd_config

/usr/sbin/sshd -D -e "$@"