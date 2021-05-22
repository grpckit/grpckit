#!/bin/bash -ex
source ./variables.sh

cd ./examples

build='omniproto'
tag=${CONTAINER}/${build}:${GRPC_VERSION}_${BUILD_VERSION}

rm -rf ./gen

docker run --rm --user $(id -u):$(id -g) -v ${PWD}:/workspace ${tag}
echo $?

# Verify the expected files are generated
test descriptors.pb
test helloworld.pb.go
test helloworld.pb.validate.go
test helloworld.swagger.json
test helloworld_grpc.pb.go
test helloworld_grpc_web_pb.js
test helloworld_pb2.py
