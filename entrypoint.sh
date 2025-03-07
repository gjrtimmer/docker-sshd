#!/usr/bin/env bash

# Collecting Container IP
#echo "Container IP: $(ip addr | grep "inet" |grep -Fv 127.0.0.1 |grep -Fv ::1 |awk '{print $2}'| grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}?')"

trap "echo SIGINT; exit" SIGINT
trap "echo SIGTERM; exit" SIGTERM

: "${SSH_USERNAME:=ubuntu}"
: "${SSH_PASSWORD:?"Error: SSH_PASSWORD environment variable is not set."}"

if ! id "${SSH_USERNAME}" &>/dev/null; then
    useradd -ms /bin/bash "${SSH_USERNAME}"
    echo "User ${SSH_USERNAME} created with the provided password"
fi

# Update password
echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd

# Start the SSH server
echo "Starting SSH server..."
exec /usr/sbin/sshd -D
