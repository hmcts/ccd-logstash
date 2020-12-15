#!/usr/bin/env bash

docker build -t hmcts/ccd/logstash:ccd-logstash-latest --build-arg conf=ccd_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-cmc-logstash-latest --build-arg conf=ccdcmc_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-divorce-logstash-latest --build-arg conf=ccddivorce_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-ethos-logstash-latest --build-arg conf=ccdethos_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-probate-logstash-latest --build-arg conf=ccdprobate_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-sscs-logstash-latest --build-arg conf=ccdsscs_logstash.conf.in .

docker build -t hmcts/ccd/logstash:ccd-sweeper-logstash-latest --build-arg conf=sweeper_logstash.conf.in .

docker build -t hmcts/ccd/logstash:testall-latest --build-arg conf=ccdtestall_logstash.conf.in .

