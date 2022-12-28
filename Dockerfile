FROM oraclelinux:8

RUN (yum update -y; \
    yum install -y openssh-server \
                   openssh-clients \
                   initscripts \
                   epel-release \
                   wget \
                   passwd \
                   tar \
                   net-tools \
                   oracle-database-preinstall-21c \
                   file \
                   crontabs \
                   sudo \
                   less \
                   unzip; \
    yum install -y net-tools \
                   oracle-database-preinstall-21c \
                   hostname \
                   file; \
    yum clean all)

# -----------------------------------------------------------------
# Install all tools for dev
# -----------------------------------------------------------------

RUN (dnf group install --with-optional --assumeyes "Development Tools")

# -----------------------------------------------------------------
# Create and configure users.
# -----------------------------------------------------------------

RUN (useradd dev)
RUN (echo 'dev:dev' | chpasswd)
# RUN (useradd oracle)
RUN (echo 'oracle:oracle' | chpasswd)
RUN (echo 'root:root' | chpasswd)

RUN (echo "dev   ALL=(ALL)      NOPASSWD: ALL" >> /etc/sudoers)
RUN (echo "oracle   ALL=(ALL)      NOPASSWD: ALL" >> /etc/sudoers)

# -----------------------------------------------------------------
# Configure SSH server.
# -----------------------------------------------------------------

RUN (ssh-keygen -A; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

ADD data/install_ssh_keys.sh /tmp
RUN (chmod a+xr /tmp/install_ssh_keys.sh)

USER dev
RUN (/tmp/install_ssh_keys.sh)
USER oracle
RUN (/tmp/install_ssh_keys.sh)
USER root
RUN (/tmp/install_ssh_keys.sh)

# -----------------------------------------------------------------
# Install Oracle EX
#
# Notes:
#
# - ORACLE_DOCKER_INSTALL needs to by exported
#   (export ORACLE_DOCKER_INSTALL=true)
# - See: https://docs.oracle.com/en/database/oracle/oracle-database/21/xeinl/installing-oracle-database-xe.html#GUID-3F29EE7C-4546-49EE-B894-027EE3E371BF
# -----------------------------------------------------------------

USER root
ADD data/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm /tmp
ENV ORACLE_DOCKER_INSTALL=true
RUN (rpm -ivh /tmp/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm)
RUN (sed -i "s/^\s*LISTENER_PORT=.*$/LISTENER_PORT=1521/" /etc/sysconfig/oracle-xe-21c.conf)
RUN (sed -i "s/^\s*EM_EXPRESS_PORT=.*$/EM_EXPRESS_PORT=5550/" /etc/sysconfig/oracle-xe-21c.conf)
RUN ((echo "root"; echo "root";) | /etc/init.d/oracle-xe-21c configure)

# -----------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------

RUN (rm /tmp/install_ssh_keys.sh; \
     rm /tmp/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm)

# -----------------------------------------------------------------
# Start the SSH daemon.
# -----------------------------------------------------------------

EXPOSE 22 1521 5550

CMD ["/usr/sbin/sshd", "-D"]

