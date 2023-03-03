#!/bin/bash

docker build --tag custom-action .
docker run --rm custom-action

