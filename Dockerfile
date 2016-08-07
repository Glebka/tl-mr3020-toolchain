FROM ubuntu:16.04
RUN apt-get update && apt-get install -y git-core build-essential libssl-dev libncurses5-dev unzip gawk wget subversion mercurial python file openssh-server libssl-dev libffi-dev
#RUN useradd -s /bin/bash -m -d /home/user -G ssh -puser123 user
#RUN usermod -a -G ssh user
#RUN echo 'user:user123' | chpasswd
#RUN mkdir /var/run/sshd
#RUN su user
RUN mkdir /openwrt
RUN git clone git://git.openwrt.org/15.05/openwrt.git /openwrt
RUN cd /openwrt && make defconfig
ADD tl-mr3020.cfg /openwrt/.config
ADD build.sh /openwrt/build.sh
RUN chmod +x /openwrt/build.sh
VOLUME /openwrt
#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]
