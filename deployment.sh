#!/bin/bash
cd $(dirname $(realpath $0))

docker build -t gitlab/bash:latest .