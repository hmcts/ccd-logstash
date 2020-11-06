#!/usr/bin/env bash

docker build -t hmcts/ccd/logstash:ccd-latest --build-arg conf=ccd_logstash.conf.in .

docker build -t hmcts/ccd/logstash:cmc-latest --build-arg conf=ccdcmc_logstash.conf.in .

docker build -t hmcts/ccd/logstash:divorce-latest --build-arg conf=ccddivorce_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ethos-latest --build-arg conf=ccdethos_logstash.conf.in .

docker build -t hmcts/ccd/logstash:probate-latest --build-arg conf=ccdprobate_logstash.conf.in .

docker build -t hmcts/ccd/logstash:sscs-latest --build-arg conf=ccdsscs_logstash.conf.in .

