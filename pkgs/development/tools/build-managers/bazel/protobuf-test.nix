{ bazel
, bazelTest
, fetchFromGitHub
, fetchurl
, stdenv
, darwin
, extraBazelArgs ? ""
, lib
, openjdk8
, jdk11_headless
, runLocal
, runtimeShell
, writeScript
, writeText
, distDir
}:

let

  # Use builtins.fetchurl to avoid IFD, in particular on hydra
  lockfile =
    let version = "7.0.0-pre.20230917.3";
    in builtins.fetchurl {
      url = "https://raw.githubusercontent.com/bazelbuild/bazel/${version}/MODULE.bazel.lock";
      sha256 = "0z6mlz8cn03qa40mqbw6j6kd6qyn4vgb3bb1kyidazgldxjhrz6y";
    };

  MODULE = writeText "MODULE.bazel" ''
    #bazel_dep(name = "bazel_skylib", version = "1.4.1")
    #bazel_dep(name = "protobuf", version = "21.7", repo_name = "com_google_protobuf")
    bazel_dep(name = "protobuf", version = "21.7")
    #bazel_dep(name = "grpc", version = "1.48.1.bcr.1", repo_name = "com_github_grpc_grpc")
    #bazel_dep(name = "platforms", version = "0.0.7")
    #bazel_dep(name = "rules_pkg", version = "0.9.1")
    #bazel_dep(name = "stardoc", version = "0.5.3", repo_name = "io_bazel_skydoc")
    #bazel_dep(name = "zstd-jni", version = "1.5.2-3.bcr.1")
    #bazel_dep(name = "blake3", version = "1.3.3.bcr.1")
    #bazel_dep(name = "zlib", version = "1.3")
    #bazel_dep(name = "rules_cc", version = "0.0.8")
    #bazel_dep(name = "rules_java", version = "6.3.1")
    bazel_dep(name = "rules_proto", version = "5.3.0-21.7")
    #bazel_dep(name = "rules_jvm_external", version = "5.2")
    #bazel_dep(name = "rules_python", version = "0.24.0")
    #bazel_dep(name = "rules_testing", version = "0.0.4")
  '';

  WORKSPACE = writeText "WORKSPACE" ''
    workspace(name = "our_workspace")

    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    http_archive(
        name = "rules_proto",
        sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
        strip_prefix = "rules_proto-5.3.0-21.7",
        urls = [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
        ],
    )
    load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
    rules_proto_dependencies()
    rules_proto_toolchains()
  '';

  personProto = writeText "person.proto" ''
    syntax = "proto3";

    package person;

    message Person {
      string name = 1;
      int32 id = 2;
      string email = 3;
    }
  '';

  personBUILD = writeText "BUILD" ''
    load("@rules_proto//proto:defs.bzl", "proto_library")

    proto_library(
        name = "person_proto",
        srcs = ["person.proto"],
        visibility = ["//visibility:public"],
    )

    java_proto_library(
        name = "person_java_proto",
        deps = [":person_proto"],
    )

    cc_proto_library(
        name = "person_cc_proto",
        deps = [":person_proto"],
    )
  '';

  toolsBazel = writeScript "bazel" ''
    #! ${runtimeShell}

    export CXX='${stdenv.cc}/bin/clang++'
    export LD='${darwin.cctools}/bin/ld'
    export LIBTOOL='${darwin.cctools}/bin/libtool'
    export CC='${stdenv.cc}/bin/clang'

    # XXX: hack for macosX, this flags disable bazel usage of xcode
    # See: https://github.com/bazelbuild/bazel/issues/4231
    export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

    exec "$BAZEL_REAL" "$@"
  '';

  workspaceDir = runLocal "our_workspace" { } (''
    mkdir $out
    cp ${MODULE} $out/MODULE.bazel
    cp ${lockfile} $out/MODULE.bazel.lock
    cp ${WORKSPACE} $out/WORKSPACE
    touch $out/BUILD.bazel
    mkdir $out/person
    cp ${personProto} $out/person/person.proto
    cp ${personBUILD} $out/person/BUILD.bazel
  ''
  + (lib.optionalString stdenv.isDarwin ''
    mkdir $out/tools
    cp ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "bazel-test-protocol-buffers";
    inherit workspaceDir;
    bazelPkg = bazel;
    buildInputs = [ (if lib.strings.versionOlder bazel.version "5.0.0" then openjdk8 else jdk11_headless) ];
    bazelScript = ''
      ${bazel}/bin/bazel \
        build \
        --verbose_failures \
        --curses=no \
        --sandbox_debug \
        --strict_java_deps=off \
        --strict_proto_deps=off \
        ${extraBazelArgs} \
        //... \
    '' + lib.optionalString (lib.strings.versionOlder bazel.version "5.0.0") ''
      --host_javabase='@local_jdk//:jdk' \
      --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
      --javabase='@local_jdk//:jdk' \
    '' + lib.optionalString (stdenv.isDarwin) ''
      --cxxopt=-x --cxxopt=c++ --host_cxxopt=-x --host_cxxopt=c++ \
      --linkopt=-stdlib=libc++ --host_linkopt=-stdlib=libc++ \
    '';
  };

in
testBazel
