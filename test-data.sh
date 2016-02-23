#!/bin/sh
curl -H "Content-type: application/json" -XPOST -d@processor-local.json http://localhost:9292/v1/processors
curl -H "Content-type: application/json" -XPOST -d@invocations.json http://localhost:9292/v1/invocations
