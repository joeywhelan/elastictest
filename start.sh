#!/bin/bash
docker compose up -d
docker cp elastictest-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt east-ca.crt
source .env

echo -e "\n*** ElasticSearch endpoint: https://$EAST_ELASTIC_IP:9200 ***"
echo -e "*** Kibana endpoint: http://$EAST_KIBANA_IP:5601 ***"