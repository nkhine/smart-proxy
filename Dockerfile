FROM public.ecr.aws/ubuntu/ubuntu:22.04_stable


ENV  SQUID_VERSION=5.2-1ubuntu4.3 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN apt-get update  && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* && rm -rf /var/lib/apt/lists/*

# Workaround for https://github.com/moby/moby/issues/31243
RUN usermod -a -G tty proxy
# Set the GID and UID for the "squid" user
# RUN groupmod -g 1001 proxy && usermod -u 1001 -g 1001 proxy

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

COPY squid.conf /etc/squid/squid.conf
COPY allowedlist.txt /etc/squid/allowedlist.txt


EXPOSE 3128/tcp
USER proxy
ENTRYPOINT ["/sbin/entrypoint.sh"]