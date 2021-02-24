#!/bin/bash

exec docker run --name honkit -it -v $(pwd):$(pwd) -w $(pwd) --rm -it -p 4000:4000 --init myhonkit:latest honkit serve src docs
