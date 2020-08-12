
FROM docker.elastic.co/logstash/logstash:6.4.2
ARG conf=ccd_logstash.conf.in
LABEL maintainer="https://github.com/hmcts/ccd-logstash"
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
COPY packer_images/${conf} /usr/share/logstash/pipeline/logstash.conf
COPY lib/postgresql-42.2.2.jar /usr/share/logstash
