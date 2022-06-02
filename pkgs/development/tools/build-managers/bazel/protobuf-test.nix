{
  bazel
, bazelTest
, fetchFromGitHub
, fetchurl
, gccStdenv
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
  com_google_protobuf = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v3.13.0";
    sha256 = "1nqsvi2yfr93kiwlinz8z7c68ilg1j75b2vcpzxzvripxx5h6xhd";
  };

  bazel_skylib = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-skylib";
    rev = "2ec2e6d715e993d96ad6222770805b5bd25399ae";
    sha256 = "1z2r2vx6kj102zvp3j032djyv99ski1x1sl4i3p6mswnzrzna86s";
  };

  rules_python = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "rules_python";
    rev = "c8c79aae9aa1b61d199ad03d5fe06338febd0774";
    sha256 = "1zn58wv5wcylpi0xj7riw34i1jjpqahanxx8y9srwrv0v93b6pqz";
  };

  rules_proto = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "rules_proto";
    rev = "a0761ed101b939e19d83b2da5f59034bffc19c12";
    sha256 = "09lqfj5fxm1fywxr5w8pnpqd859gb6751jka9fhxjxjzs33glhqf";
  };

  net_zlib = fetchurl rec {
    url = "https://zlib.net/zlib-1.2.11.tar.gz";
    sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1";

    passthru.sha256 = sha256;
  };

  WORKSPACE = writeText "WORKSPACE" ''
    workspace(name = "our_workspace")

    load("//:proto-support.bzl", "protobuf_deps")
    protobuf_deps()
    load("@rules_proto//proto:repositories.bzl", "rules_proto_toolchains")
    rules_proto_toolchains()
    '';

  protoSupport = writeText "proto-support.bzl" ''
    """Load dependencies needed to compile the protobuf library as a 3rd-party consumer."""

    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    def protobuf_deps():
        """Loads common dependencies needed to compile the protobuf library."""

        if "zlib" not in native.existing_rules():
            # proto_library, cc_proto_library, and java_proto_library rules implicitly
            # depend on @com_google_protobuf for protoc and proto runtimes.
            # This statement defines the @com_google_protobuf repo.
            native.local_repository(
                name = "com_google_protobuf",
                path = "${com_google_protobuf}",
            )
            native.local_repository(
                name = "bazel_skylib",
                path = "${bazel_skylib}",
            )
            native.local_repository(
                name = "rules_proto",
                path = "${rules_proto}",
            )
            native.local_repository(
                name = "rules_python",
                path = "${rules_python}",
            )

            http_archive(
                name = "zlib",
                build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
                sha256 = "${net_zlib.sha256}",
                strip_prefix = "zlib-1.2.11",
                urls = ["file://${net_zlib}"],
            )
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

    export CXX='${gccStdenv.cc}/bin/g++'
    export LD='${gccStdenv.cc}/bin/ld'
    export CC='${gccStdenv.cc}/bin/gcc'

    # XXX: hack for macosX, this flags disable bazel usage of xcode
    # See: https://github.com/bazelbuild/bazel/issues/4231
    export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

    exec "$BAZEL_REAL" "$@"
  '';

  workspaceDir = runLocal "our_workspace" {} (''
    mkdir $out
    cp ${WORKSPACE} $out/WORKSPACE
    touch $out/BUILD.bazel
    cp ${protoSupport} $out/proto-support.bzl
    mkdir $out/person
    cp ${personProto} $out/person/person.proto
    cp ${personBUILD} $out/person/BUILD.bazel
  ''
  + (lib.optionalString gccStdenv.isDarwin ''
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
        --distdir=${distDir} \
          --verbose_failures \
          --curses=no \
          --sandbox_debug \
          //... \
    '' + lib.optionalString (lib.strings.versionOlder bazel.version "5.0.0") ''
          --host_javabase='@local_jdk//:jdk' \
          --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
          --javabase='@local_jdk//:jdk' \
    '';
  };

in testBazel
