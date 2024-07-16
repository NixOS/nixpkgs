{ bazel
, bazelTest
, bazel-examples
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

  workspaceDir = runLocal "our_workspace" {} (''
    cp -r ${bazel-examples}/java-tutorial $out
    find $out -type d -exec chmod 755 {} \;
  ''
  + (lib.optionalString stdenv.isDarwin ''
    mkdir $out/tools
    cp ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "${bazel.pname}-test-java";
    inherit workspaceDir;
    bazelPkg = bazel;
    buildInputs = [ (if lib.strings.versionOlder bazel.version "5.0.0" then openjdk8 else jdk11_headless) ];
    bazelScript = ''
      ${bazel}/bin/bazel \
        run \
        --announce_rc \
        ${lib.optionalString (lib.strings.versionOlder "5.0.0" bazel.version)
          "--toolchain_resolution_debug='@bazel_tools//tools/jdk:(runtime_)?toolchain_type'"
        } \
        --distdir=${distDir} \
        --verbose_failures \
        --curses=no \
        --strict_java_deps=off \
        //:ProjectRunner \
    '' + lib.optionalString (lib.strings.versionOlder bazel.version "5.0.0") ''
        --host_javabase='@local_jdk//:jdk' \
        --java_toolchain='@bazel_tools//tools/jdk:toolchain_hostjdk8' \
        --javabase='@local_jdk//:jdk' \
    '' + extraBazelArgs;
  };

in testBazel

