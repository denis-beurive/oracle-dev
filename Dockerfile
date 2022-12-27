# Connect to the container using SSH (password: "root"):
#
#       docker run --detach -it --rm -p 2222:22/tcp oracle-8
#       ssh -o IdentitiesOnly=yes -p 2222 root@localhost

FROM oraclelinux:8

RUN (yum update -y; \
    yum install -y openssh-server \
                   openssh-clients \
                   initscripts \
                   epel-release \
                   wget \
                   passwd \
                   tar \
                   crontabs \
                   unzip; \
    yum clean all)

RUN (ssh-keygen -A; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

RUN (echo "root:root" | chpasswd)

# Install all tools for dev
RUN (dnf group install --with-optional --assumeyes "Development Tools")

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


# WORKDIR /app
# COPY . .


