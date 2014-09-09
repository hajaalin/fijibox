FROM hajaalin/pythonbox-root

RUN apt-get install -y wget \
&& cd / \
&& wget http://fiji.sc/downloads/Life-Line/fiji-linux64-20140602.tar.gz \
&& tar xf fiji-linux64-20140602.tar.gz \
&& rm fiji-linux64-20140602.tar.gz \
&& chown -R dev: Fiji.app

ENV PATH $PATH:/Fiji.app

RUN apt-get install -y openssh-server \
&& mkdir /var/run/sshd
RUN echo 'dev:123'|chpasswd

EXPOSE 22
#ADD authorized_keys /home/dev/.ssh/authorized_keys
#RUN chown dev:dev /home/dev/.ssh/authorized_keys
#RUN chmod 0600 /home/dev/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"] 
