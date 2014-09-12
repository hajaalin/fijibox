FROM hajaalin/devbox

# set up SSH access for 'dev'
RUN apt-get install -y openssh-server \
&& mkdir /var/run/sshd \
&& echo 'dev:123'|chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"] 

# install Fiji: have to figure out how to manage new versions...
ENV PATH $PATH:/Fiji.app
RUN apt-get install -y wget \
&& cd / \
&& wget http://fiji.sc/downloads/Life-Line/fiji-linux64-20140602.tar.gz \
&& tar xf fiji-linux64-20140602.tar.gz \
&& rm fiji-linux64-20140602.tar.gz \
&& chown -R dev: Fiji.app




