# ccd-logstash

This repository contains a pipeline to: 
* build a Logstash image 
* deploy an instance of Logstash which connects to a ccd Elastic Search cluster
    
The image and the Lostash instance will end up in a resource group called <product>-logstash-<env>, e.g. ccd-logstash-sandbox
and will be connected to the ES cluster in ccd-elastic-search-<env>

Multiple Logstash images can be built, their name is suffixed with a timestamp. The deploy considers only the latest image  
    
Note:
the ccd Elastic Search cluster must already exist for the Logstash deploy to be successful

Create Logstash instances of all services:

To create logstash instances of all services CCD is supporting execute build-logstash-instances.sh file from ccd-logstash folder 

 ```bash
 ./bin/build-logstash-instances.sh
 ```
 **./build-logstash-instances.sh**
 
 Or run below docker-compose command from ccd-logstash folder
 
 **docker-compose -f build-logstash-instances.yml build**
 
 After executing one of the above commands you can see the below images in local docker repository.
 
```bash 
 **REPOSITORY           TAG** 
 hmcts/ccd/logstash   ccdsscs-latest   
 hmcts/ccd/logstash   ccdprobate-latest
 hmcts/ccd/logstash   ccdethos-latest  
 hmcts/ccd/logstash   ccddivorce-latest
 hmcts/ccd/logstash   ccdcmc-latest    
 hmcts/ccd/logstash   ccd-latest  
``` 