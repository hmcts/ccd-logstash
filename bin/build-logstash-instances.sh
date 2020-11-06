#!/usr/bin/env bash

docker build -t hmcts/ccd/logstash:ccd-latest --build-arg conf=ccd_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccdcmc-latest --build-arg conf=ccdcmc_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccddivorce-latest --build-arg conf=ccddivorce_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccdethos-latest --build-arg conf=ccdethos_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccdprobate-latest --build-arg conf=ccdprobate_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccdsscs-latest --build-arg conf=ccdsscs_logstash.conf.in .

