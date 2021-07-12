#Please note that there are now multiple logstash images that you may wish to use to test your deployment. to do this you need to replace the "ccd_logstash.conf.in" with "ccdcmc_logstash.conf.in", "ccdsscs_logstash.conf.in", "ccdprobate_logstash.conf.in", "ccddivorce_logstash.conf.in" or "sweeper_logstash.conf.in"

FROM docker.elastic.co/logstash/logstash:6.4.2
ARG conf=ccdprobate_logstash.conf.in
LABEL maintainer="https://github.com/hmcts/ccd-logstash"
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
COPY packer_images/${conf} /usr/share/logstash/pipeline/logstash.conf
COPY lib/postgresql-42.2.2.jar /usr/share/logstash
