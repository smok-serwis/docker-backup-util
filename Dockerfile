FROM smokserwis/build:docker-only

RUN clean-apt-install pv

ENV PROFILE_DIRECTORY=/profiles \
    RATE_LIMIT=100m \
    TAR_NICE=0

ADD run_backup.sh /run_backup.sh
RUN chmod ugo+x /run_backup.sh

VOLUME /backups /root /profiles

ENTRYPOINT ["/run_backup.sh"]
