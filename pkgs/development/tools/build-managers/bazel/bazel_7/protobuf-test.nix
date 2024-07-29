{ bazel
, Foundation
, bazelTest
, callPackage
, cctools
, darwin
, distDir
, extraBazelArgs ? ""
, fetchurl
, jdk11_headless
, lib
, libtool
, lndir
, openjdk8
, repoCache
, runLocal
, runtimeShell
, stdenv
, symlinkJoin
, tree
, writeScript
, writeText
}:

# This test uses bzlmod because I could not make it work without it.
# This is good, because we have at least one test with bzlmod enabled.
# However, we have to create our own lockfile, wich is quite a big file by
# itself.

let
  # To update the lockfile, run
  #    $ nix-shell -A bazel_7.tests.vanilla.protobuf
  #    [nix-shell]$ genericBuild # (wait a bit for failure, or kill it)
  #    [nix-shell]$ rm -f MODULE.bazel.lock
  #    [nix-shell]$ bazel mod deps --lockfile_mode=update
  #    [nix-shell]$ cp MODULE.bazel.lock $HERE/protobuf-test.MODULE.bazel.lock
  lockfile = ./protobuf-test.MODULE.bazel.lock;

  protobufRepoCache = callPackage ./bazel-repository-cache.nix {
    # We are somewhat lucky that bazel's own lockfile works for our tests.
    # Use extraDeps if the tests need things that are not in that lockfile.
    # But most test dependencies are bazel's builtin deps, so that at least aligns.
    inherit lockfile;

    # Remove platform-specific binaries, as they are large and useless.
    requiredDepNamePredicate = name:
      null == builtins.match ".*(macos|osx|linux|win|android|maven).*" name;
  };

  mergedRepoCache = symlinkJoin {
    name = "mergedDistDir";
    paths = [ protobufRepoCache distDir ];
  };

  MODULE = writeText "MODULE.bazel" ''
    bazel_dep(name = "rules_proto", version = "5.3.0-21.7")
    bazel_dep(name = "protobuf", version = "21.7")
    bazel_dep(name = "zlib", version = "1.3")
  '';

  WORKSPACE = writeText "WORKSPACE" ''
    # Empty, we use bzlmod instead
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
    export LD='${cctools}/bin/ld'
    export LIBTOOL='${cctools}/bin/libtool'
    export CC='${stdenv.cc}/bin/clang'

    # XXX: hack for macosX, this flags disable bazel usage of xcode
    # See: https://github.com/bazelbuild/bazel/issues/4231
    export BAZEL_USE_CPP_ONLY_TOOLCHAIN=1

    export HOMEBREW_RUBY_PATH="foo"

    exec "$BAZEL_REAL" "$@"
  '';

  workspaceDir = runLocal "our_workspace" { } (''
    mkdir $out
    cp ${MODULE} $out/MODULE.bazel
    cp ${./protobuf-test.MODULE.bazel.lock} $out/MODULE.bazel.lock
    #cp ${WORKSPACE} $out/WORKSPACE
    touch $out/WORKSPACE
    touch $out/BUILD.bazel
    mkdir $out/person
    cp ${personProto} $out/person/person.proto
    cp ${personBUILD} $out/person/BUILD.bazel
  ''
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    echo 'tools bazel created'
    mkdir $out/tools
    install ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "bazel-test-protocol-buffers";
    inherit workspaceDir;
    bazelPkg = bazel;
    buildInputs = [
      (if lib.strings.versionOlder bazel.version "5.0.0" then openjdk8 else jdk11_headless)
      tree
      bazel
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Foundation
      darwin.objc4
    ];

    bazelScript = ''
      ${bazel}/bin/bazel \
        build \
        --repository_cache=${mergedRepoCache} \
        ${extraBazelArgs} \
        --enable_bzlmod \
        --lockfile_mode=error \
        --verbose_failures \
        //... \
    '' + lib.optionalString (lib.strings.versionOlder bazel.version "5.0.0") ''
        --host_javabase='@local_jdk//:jdk' \
        --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
        --javabase='@local_jdk//:jdk' \
    '' + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
        --cxxopt=-x --cxxopt=c++ --host_cxxopt=-x --host_cxxopt=c++ \
    '' + ''

    '';
  };

in
testBazel
