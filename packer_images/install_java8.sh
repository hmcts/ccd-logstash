#!/bin/bash

echo "updating apt-get"
(sudo apt-get -y update && sudo apt-get -y install -f && sudo apt-get -y autoremove || (sleep 15; sudo apt-get -y update)) > /dev/null
echo "updated apt-get"
echo "installing java"
(sudo apt-get -yq install openjdk-8-jdk || (sleep 15; sudo apt-get -yq install openjdk-8-jdk))
command -v java >/dev/null 2>&1 || { echo "java did not get installed" >&2; exit 50; }
echo "installed java"
