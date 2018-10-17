#!/bin/bash

# Add the Java 8 repository.
sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

sudo apt-get update

# Set the "don't bother us" option to install.
echo debconf shared/accepted-oracle-license-v1-1 select true | \
sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
sudo debconf-set-selections

# Install Java 8.
sudo apt-get -y install oracle-java8-installer

cd /var/lib/dpkg/info
sudo sed -i 's|JAVA_VERSION=8u171|JAVA_VERSION=8u181|' oracle-java8-installer.*
sudo sed -i 's|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/|' oracle-java8-installer.*
sudo sed -i 's|SHA256SUM_TGZ="b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982"|SHA256SUM_TGZ="1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3"|' oracle-java8-installer.*
sudo sed -i 's|J_DIR=jdk1.8.0_171|J_DIR=jdk1.8.0_181|' oracle-java8-installer.*

sudo apt-get -y install oracle-java8-installer oracle-java8-set-default
