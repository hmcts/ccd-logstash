# ccd-logstash

This repository contains a pipeline to: 
* build a Logstash image 
* deploy an instance of Logstash which connects to a ccd Elastic Search cluster
    
The image and the Lostash instance will end up in a resource group called <product>-logstash-<env>, e.g. ccd-logstash-sandbox
and will be connected to the ES cluster in ccd-elastic-search-<env>

Multiple Logstash images can be built, their name is suffixed with a timestamp. The deploy considers only the latest image  
    
Note:
the ccd Elastic Search cluster must already exist for the Logstash deploy to be successful