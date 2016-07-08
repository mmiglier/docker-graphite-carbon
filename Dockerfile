FROM ubuntu:xenial
MAINTAINER Sascha Wessel <swessel@gr4yweb.de>

# Update System
RUN apt-get update -y && apt-get upgrade -y

# Install Dependencies
RUN apt-get install -y python-ldap python-cairo python-django python-twisted python-django-tagging python-simplejson python-memcache python-pysqlite2 python-tz python-pip supervisor
RUN pip install whisper==0.9.15
RUN pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.15

# Create Directories
RUN mkdir -p /data/graphite/storage/whisper
RUN	touch /data/graphite/storage/graphite.db /data/graphite/storage/index
RUN	chmod 0775 /data/graphite/storage /data/graphite/storage/whisper
RUN	chmod 0664 /data/graphite/storage/graphite.db
RUN cp /var/lib/graphite/conf/storage-aggregation.conf.example /var/lib/graphite/conf/storage-aggregation.conf 
RUN cp /var/lib/graphite/conf/storage-schemas.conf.example /var/lib/graphite/conf/storage-schemas.conf 

# Add Config file
ADD	carbon.conf /var/lib/graphite/conf/carbon.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf

# Carbon line receiver port
EXPOSE 2003
# Carbon UDP receiver port
EXPOSE 2003/udp
# Carbon pickle receiver port
EXPOSE 2004
# Carbon cache query port
EXPOSE 7002

# Volumes
VOLUME /data/graphite

CMD ["/usr/bin/supervisord"]