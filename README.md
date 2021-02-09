# gRPC/Protocol Buffers Containerized Toolkit

This repo builds a docker container for the `protoc` command line utility, several gRPC plugins, and
several grpc tools. It is meant to provide a swiss army knife docker container for all your gRPC
needs. In multi-team environments this is essential to provide specific configurations to teammates and your CICD pipeline.

It is recommended to use this with [grpckit/omniproto](https://github.com/grpckit/omniproto). `omniproto`
lets you declare your gRPC generation declartively. This repo
builds a docker container for `grpckit` and `omniproto` as an
entrypoint.

## Features

- Docker images for:

  - `grpckit` a default container with all the goodies. No cmd, args, or entrypoint defined.
  - `protoc` with `grpckit/protoc` [grpckit/omniproto](https://github.com/grpckit/omniproto)
  - `buf`, containing the [buf.build](https://buf.build/)toolkit.
  - `omniproto`, to generate protos with [omniproto](https://github.com/grpckit/omniproto)

It is recommended to use `omniproto`:

```
docker run -v $(pwd):/workspace --rm grpckit/omniproto
```

## Omniproto configuration

The `omniproto.yaml` config file controls the behavior of the generators.

Each generator is configured in the plugins folder as shown below. 
The arguments are specific to each generator, so you will need to read the instructions for each step:

  ```yaml
  # cd ./examples
  rootdir: protos
  output: gen
  sources:
    - helloworld.proto
  plugins:
    - name: go # Go, go-grpc, and validation generators
      args: paths=source_relative
    - name: go-grpc
      args: paths=source_relative
    - name: validate
      args: paths=source_relative,lang=go
  
    - name: grpc-web  # Typescript & grpc-web generator
      args: import_style=commonjs,mode=grpcwebtext
  
    - name: python  # Python generator
      output: gen

    - name: openapiv2  # Openapi generator
      args: logtostderr=true,json_names_for_fields=false
  
  # Descriptors generator, this would be used with grpc-transcoding to convert JSON -> GRPC requests
  descriptors:
    output: gen/descriptors.pb
    enabled: true
    include_imports: true
    include_source_info: true

  debug: true
  ```

## Supported plugins

- Go's new protocolbuffer library, [google.golang.org/protobuf](https://google.golang.org/protobuf)
- [Gogo's Go fork](https://github.com/gogo/protobuf), with gogo and gogofast
- [Scala](https://github.com/scalapb/ScalaPB) and [Java](https://github.com/grpc/grpc-java) native libraries
- [grpc-web](https://github.com/grpc/grpc-web)
- The following additions:
  - [ckaznocha/protoc-gen-lint](https://github.com/ckaznocha/protoc-gen-lint)
  - [psuedomuto/protoc-gen-doc](https://github.com/pseudomuto/protoc-gen-doc)
  - [envoyproxy/protoc-gen-validate](https://github.com/envoyproxy/protoc-gen-validate)
  - [coinbase/protoc-gen-rbi](https://github.com/coinbase/protoc-gen-rbi) (Ruby Sorbet Types)

If you're having trouble, see [Docker troubleshooting](#docker-troubleshooting) below.

## Tag Conventions

A tag pattern of `<GRPC_VERSION>_<CONTAINER_VERSION>` is used for all images.
Example is `grpckit/omniproto:1.28_0` for gRPC version `1.28`. The `_0` suffix allows for inter-grpc releases as necessary. The `latest` tag will always point to the most recent version.

It is highly recommend to pin to a specific gRPC version in your toolchain for repeatable builds.

## Protorepo Includes

Unlike the original [namely/docker-protoc](https://github.com/namely/docker-protoc), this repo does not include extraneous
proto files like the Google APIs, or protos from plugin binaries like `validator`. These protos should be included
with your source protos, preferably in a protorepo (a monorepo for protofiles) that's submoduled into your project.
In practice, assuming the system has proto files available outside the standard protobuf files fails, so it's
best to be explicit.

The omniproto command line repo has a simple makefile script to
apply protofiles from other repos easily.

## Contributing

If you make changes, or add a container for another language compiler, this repo
has simple scripts that can build projects. You can run the following within the
all/ folder:

```sh
$ make build
```

This will build all of the known containers.

```sh
$ make push
```

This will build and push the containers to the org specified in variables.sh.
