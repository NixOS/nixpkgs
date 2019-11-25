{
  bazel
, bazelTest
, fetchFromGitHub
, fetchurl
, gccStdenv
, lib
, openjdk8
, runLocal
, runtimeShell
, writeScript
, writeText
, distDir
}:

let
  com_google_protobuf = fetchurl rec {
    url = "https://github.com/protocolbuffers/protobuf/archive/v${passthru.version}.tar.gz";
    sha256 = "6adf73fd7f90409e479d6ac86529ade2d45f50494c5c10f539226693cb8fe4f7";

    passthru.sha256 = sha256;
    passthru.version = "3.10.1";
  };

  bazel_skylib = fetchurl rec {
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-${passthru.version}.tar.gz";
    sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44";

    passthru.sha256 = sha256;
    passthru.version = "1.0.2";
  };

  zlib = fetchurl rec {
    url = "https://github.com/madler/zlib/archive/v${passthru.version}.tar.gz";
    sha256 = "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff";

    passthru.sha256 = sha256;
    passthru.version = "1.2.11";
  };

  six = fetchurl rec {
    url = "https://pypi.python.org/packages/source/s/six/six-${passthru.version}.tar.gz";
    sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73";

    passthru.sha256 = sha256;
    passthru.version = "1.12.0";
  };

  rules_cc = fetchurl rec {
    url = "https://github.com/bazelbuild/rules_cc/archive/${passthru.version}.tar.gz";
    sha256 = "29daf0159f0cf552fcff60b49d8bcd4f08f08506d2da6e41b07058ec50cfeaec";

    passthru.sha256 = sha256;
    passthru.version = "b7fe9697c0c76ab2fd431a891dbb9a6a32ed7c3e";
  };

  rules_java = fetchurl rec {
    url = "https://github.com/bazelbuild/rules_java/archive/${passthru.version}.tar.gz";
    sha256 = "f5a3e477e579231fca27bf202bb0e8fbe4fc6339d63b38ccb87c2760b533d1c3";

    passthru.sha256 = sha256;
    passthru.version = "981f06c3d2bd10225e85209904090eb7b5fb26bd";
  };

  rules_proto = fetchurl rec {
    url = "https://github.com/bazelbuild/rules_proto/archive/${passthru.version}.tar.gz";
    sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208";

    passthru.sha256 = sha256;
    passthru.version = "97d8af4dc474595af3900dd85cb3a29ad28cc313";
  };

  rules_python = fetchurl rec {
    url = "https://github.com/bazelbuild/rules_python/archive/${passthru.version}.tar.gz";
    sha256 = "e5470e92a18aa51830db99a4d9c492cc613761d5bdb7131c04bd92b9834380f6";

    passthru.sha256 = sha256;
    passthru.version = "4b84ad270387a7c439ebdccfd530e2339601ef27";
  };

  WORKSPACE = writeText "WORKSPACE" ''
    workspace(name = "our_workspace")

    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    http_archive(
        name = "com_google_protobuf",
        sha256 = "${com_google_protobuf.sha256}",
        strip_prefix = "protobuf-${com_google_protobuf.version}",
        urls = ["file://${com_google_protobuf}"],
    )

    load("//:proto-support.bzl", "protobuf_deps")
    protobuf_deps()
  '';

  protoSupport = writeText "proto-support.bzl" ''
    """Load dependencies needed to compile the protobuf library as a 3rd-party consumer."""

    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    def protobuf_deps():
        """Loads common dependencies needed to compile the protobuf library."""

        if not native.existing_rule("bazel_skylib"):
            http_archive(
                name = "bazel_skylib",
                sha256 = "${bazel_skylib.sha256}",
                # strip_prefix = "bazel-skylib-${bazel_skylib.version}",
                urls = ["file://${bazel_skylib}"],
            )

        if not native.existing_rule("zlib"):
            http_archive(
                name = "zlib",
                build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
                sha256 = "${zlib.sha256}",
                strip_prefix = "zlib-${zlib.version}",
                urls = ["file://${zlib}"],
            )

        if not native.existing_rule("six"):
            http_archive(
                name = "six",
                build_file = "@com_google_protobuf//:third_party/six.BUILD",
                sha256 = "${six.sha256}",
                urls = ["file://${six}"],
            )

        if not native.existing_rule("rules_cc"):
            http_archive(
                name = "rules_cc",
                sha256 = "${rules_cc.sha256}",
                strip_prefix = "rules_cc-${rules_cc.version}",
                urls = ["file://${rules_cc}"],
            )

        if not native.existing_rule("rules_java"):
            http_archive(
                name = "rules_java",
                sha256 = "${rules_java.sha256}",
                strip_prefix = "rules_java-${rules_java.version}",
                urls = ["file://${rules_java}"],
            )

        if not native.existing_rule("rules_proto"):
            http_archive(
                name = "rules_proto",
                sha256 = "${rules_proto.sha256}",
                strip_prefix = "rules_proto-${rules_proto.version}",
                urls = ["file://${rules_proto}"],
            )

        if not native.existing_rule("rules_python"):
            http_archive(
                name = "rules_python",
                sha256 = "${rules_python.sha256}",
                strip_prefix = "rules_python-${rules_python.version}",
                urls = ["file://${rules_python}"],
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
    buildInputs = [ openjdk8 ];
    bazelScript = ''
      ${bazel}/bin/bazel \
        build \
        --distdir=${distDir} \
          --host_javabase='@local_jdk//:jdk' \
          --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
          --javabase='@local_jdk//:jdk' \
          --verbose_failures \
          //...
    '';
  };

in testBazel
