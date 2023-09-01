#!/bin/bash

ATLASAPIKEY='OrgPublicKey:OrgPrivateKey'
PROMETHEUSUSER=p
PROMETHEUSPASSWORD=p

for PROJECTID in $( curl --user $ATLASAPIKEY --digest \
     --header 'Accept: application/vnd.atlas.2023-01-01+json' \
     --request GET 'https://cloud.mongodb.com/api/atlas/v2/groups?pageNum=1&itemsPerPage=10000' |jq -r .results[].id );do
echo $PROJECTID

curl --user $ATLASAPIKEY --digest \
     --header 'Accept: application/vnd.atlas.2023-01-01+json' \
     --header 'Content-Type: application/json' \
     --request POST "https://cloud.mongodb.com/api/atlas/v2/groups/$PROJECTID/integrations/PROMETHEUS" \
     --data '{"enabled": true,"listenAddress": 9216,"password": "'"$PROMETHEUSPASSWORD"'","rateLimitInterval": 0,"scheme":"https","serviceDiscovery":"http","type": "PROMETHEUS","username": "'"$PROMETHEUSUSER"'"}'

done
