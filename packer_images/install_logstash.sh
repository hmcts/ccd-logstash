#!/bin/bash

# Get the PGP Key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

apt-get update
apt-cache policy logstash
if [ -z "$LOGSTASH_VERSION" ]; then
    echo "Installing the latest Elasticsearch version"
    apt-get install logstash
else
    echo "Installing Logstash version $LOGSTASH_VERSION"
    apt-get install logstash=$LOGSTASH_VERSION
fi

sudo cp logstash.conf /etc/logstash/conf.d
mv logstash.conf /usr/share/logstash/logstash.conf
sudo cp dead_letter_pipeline.conf /usr/share/logstash
sudo cp dead_letter_indexing_pipeline.conf /usr/share/logstash
sudo cp log4j2.properties /etc/logstash
sudo cp jvm.options /etc/logstash
sudo cp logstash.yml /etc/logstash
sudo cp pipelines.yml /etc/logstash

wget -q https://jdbc.postgresql.org/download/postgresql-42.2.2.jar
mv postgresql-42.2.2.jar /usr/share/logstash/postgresql-42.2.2.jar
sudo chmod 777 /usr/share/logstash/data

sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode

# start Logstash as a service
systemctl daemon-reload
systemctl enable logstash.service
