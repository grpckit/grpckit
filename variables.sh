#!/bin/bash -e

DOCKER_BUILDKIT=1

DOCKER_REPO=${DOCKER_REPO}
NAMESPACE=${NAMESPACE:-grpckit}
GRPC_VERSION=${GRPC_VERSION:-1.37}
GRPC_JAVA_VERSION=${GRPC_JAVA_VERSION:-1.37}
GRPC_WEB_VERSION=${GRPC_WEB_VERSION:-1.2.1}
GRPC_GATEWAY_VERSION=${grpc_gateway:-2.1.0}
BUILD_VERSION=${BUILD_VERSION:-1}
CONTAINER=${DOCKER_REPO}${NAMESPACE}
LATEST=${LATEST:-false}
BUF_VERSION=${BUF_VERSION:-0.36.0}
BUILDS=("grpckit" "protoc" "buf" "omniproto")
