FROM docker.elastic.co/logstash/logstash:6.4.2
LABEL maintainer="https://github.com/hmcts/ccd-logstash"
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
COPY packer_images/ccd_logstash.conf.in /usr/share/logstash/pipeline
COPY lib/postgresql-42.2.2.jar /usr/share/logstash
