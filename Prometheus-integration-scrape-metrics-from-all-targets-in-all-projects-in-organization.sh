#!/bin/bash

ATLASAPIKEY='OrgPublicKey:OrgPrivateKey'
PROMETHEUSUSER=p
PROMETHEUSPASSWORD=p

for PROJECTID in $( curl -s --user $ATLASAPIKEY --digest \
     --header 'Accept: application/vnd.atlas.2023-01-01+json' \
     --request GET 'https://cloud.mongodb.com/api/atlas/v2/groups' |jq -r .results[].id );do


echo
curl -su $PROMETHEUSUSER:$PROMETHEUSPASSWORD "https://cloud.mongodb.com/prometheus/v1.0/groups/$PROJECTID/discovery"
echo
echo scrape every target:

for target in $(curl -su $PROMETHEUSUSER:$PROMETHEUSPASSWORD "https://cloud.mongodb.com/prometheus/v1.0/groups/$PROJECTID/discovery" | jq -r '.[].targets[]');do
 echo $target:
 curl -u p:p https://$target/metrics
done


echo 

done

