FROM smokserwis/build:docker-only

ENV PROFILE_DIRECTORY=/profiles
ENV RATE_LIMIT=100m

RUN apt-get update && \
    apt-get install -y pv && \
    apt-get clean

ADD run_backup.sh /run_backup.sh
RUN chmod ugo+x /run_backup.sh

VOLUME /volumes
VOLUME /backups
VOLUME /root
VOLUME /profiles

ENTRYPOINT ["/run_backup.sh"]
