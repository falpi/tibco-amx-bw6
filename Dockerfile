FROM centos:7

COPY home /temp 

RUN `#=======================================` && \
    `# SYSTEM UPDATE`                          && \
    `#=======================================` && \
    yum -y install sudo net-tools traceroute telnet mc wget openssh-server unzip python3 mariadb mariadb-server && \
    `#=======================================` && \
    `# SETUP SSH`                              && \
    `#=======================================` && \
    ssh-keygen -A && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "root:manager" | chpasswd && \
    `#=======================================` && \
    `# SETUP USER & ENVIRONMENT`               && \
    `#=======================================` && \
    adduser tibco && \
    usermod -aG wheel tibco && \
    mv /temp/*.* /home/tibco && \   
    rm -rf /temp  && \ 
    chmod +x /home/tibco/*.sh && \
    chmod +x /home/tibco/*.py && \    
    chmod +x /home/tibco/tibco.service && \
    ln -s /home/tibco/tibco-profile.sh /etc/profile.d/tibco-profile.sh  && \ 
    `#=======================================` && \
    `# SETUP SYSTEMD`                          && \
    `#=======================================` && \
    rm -rf /usr/bin/systemctl && \
    ln -s /home/tibco/systemctl3.py /usr/bin/systemctl && \
    ln -s /home/tibco/tibco.service /etc/systemd/system && \
    `#=======================================` && \
    `# PREPARE SERVICES`                       && \
    `#=======================================` && \
    systemctl enable mariadb && \
    systemctl enable tibco
    
CMD /home/tibco/systemctl3.py
