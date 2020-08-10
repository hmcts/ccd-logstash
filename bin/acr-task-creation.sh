#!/usr/bin/env bash

export ACR_NAME=hmctspublic
export GIT_PAT=$(az keyvault secret show --vault-name infra-vault-prod --name hmcts-github-apikey --query value -o tsv)

az acr task create \
  --registry $ACR_NAME \
  --name ccd-logstash \
  --context https://github.com/hmcts/ccd-logstash.git \
  --file acr-build.yaml \
  --git-access-token $GIT_PAT \
  --subscription DCD-CNP-PROD
