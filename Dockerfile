FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SSH_USERNAME="ubuntu"

# Install openssh-server
RUN apt-get update && \
    apt-get install -y iproute2 iputils-ping openssh-server sudo && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure SSH
RUN mkdir -p /run/sshd && \
    chmod 755 /run/sshd && \
    if ! id -u "${SSH_USERNAME}" > /dev/null 2>&1; then useradd -ms /bin/bash "${SSH_USERNAME}"; fi && \
    chown -R "${SSH_USERNAME}:${SSH_USERNAME}" "/home/${SSH_USERNAME}" && \
    chmod 755 "/home/${SSH_USERNAME}" && \
    mkdir -p "/home/${SSH_USERNAME}/.ssh" && \
    chown "${SSH_USERNAME}:${SSH_USERNAME}" "/home/${SSH_USERNAME}/.ssh" && \
    chmod 700 "/home/${SSH_USERNAME}/.ssh" && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config

COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]
