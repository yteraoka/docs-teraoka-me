#!/bin/bash

exec docker run --name honkit -it -v $(pwd):$(pwd) -w $(pwd) --rm -it myhonkit:latest honkit build src docs
