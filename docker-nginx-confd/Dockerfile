FROM nginx:1.9

RUN apt-get update &&\
    apt-get install -y -q --no-install-recommends \
      ca-certificates \
      wget &&\
    apt-get clean &&\
    rm -r /var/lib/apt/lists/*

# Install confd
ENV CONFD_VERSION 0.11.0
RUN wget https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -O /usr/local/bin/confd
RUN chmod 0755 /usr/local/bin/confd
RUN mkdir -p /etc/confd/{conf.d,templates}

# confd files
ADD ./confd/nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
ADD ./confd/nginx.toml /etc/confd/conf.d/nginx.toml
ADD ./bootstrap.sh /opt/bootstrap.sh
RUN chmod +x /opt/bootstrap.sh

# Run the bootstrap script
CMD /opt/bootstrap.sh
