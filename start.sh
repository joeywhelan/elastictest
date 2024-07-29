#!/bin/bash
docker compose up -d elasticsearch
docker compose up -d kibana

docker compose up -d postgres
while ! docker exec postgres pg_isready > /dev/null
do  
    sleep 3
done
docker exec postgres /bin/bash -c "export PGPASSWORD=postgres"
docker exec postgres createdb -U postgres Chinook
docker exec postgres psql -q Chinook -U postgres -1 -f /home/scripts/chinook.sql >/dev/null 2>&1

curl -X PUT -u elastic:elastic "localhost:9200/_connector/my-connector-id?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Music catalog",
  "index_name":  "music",
  "service_type": "postgresql"
}
'

curl -X PUT -u elastic:elastic "localhost:9200/_connector/my-connector-id/_configuration?pretty" -H 'Content-Type: application/json' -d'
{
  "values": {
    "host": "localhost",
    "port": 5432,
    "username": "postgres",
    "password": "postgres",
    "database": "Chinook",
    "schema": "public",
    "tables": "album,artist"
  }
}
'



