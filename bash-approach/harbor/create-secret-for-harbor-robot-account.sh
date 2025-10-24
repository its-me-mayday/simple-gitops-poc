#!/bin/bash

kubectl -n "$NS" create secret docker-registry "$SECRET_NAME" --docker-server="$REGISTRY" --docker-username="$USER" --docker-password="$PASS" --docker-email="$EMAIL"
