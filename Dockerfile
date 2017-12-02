FROM smokserwis/build:latest

ENV PROFILE_DIRECTORY=/profiles

ADD run_backup.sh /run_backup.sh
RUN chmod ugo+x /run_backup.sh

VOLUME /volumes
VOLUME /backups
VOLUME /root
VOLUME /profiles

ENTRYPOINT ["/run_backup.sh"]
