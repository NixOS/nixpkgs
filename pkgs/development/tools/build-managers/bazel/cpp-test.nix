{
  bazel
, bazelTest
, bazel-examples
, stdenv
, darwin
, lib
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
    cp -r ${bazel-examples}/cpp-tutorial/stage3 $out
    find $out -type d -exec chmod 755 {} \;
  ''
  + (lib.optionalString stdenv.isDarwin ''
    mkdir $out/tools
    cp ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "bazel-test-cpp";
    inherit workspaceDir;
    bazelPkg = bazel;
    bazelScript = ''
      ${bazel}/bin/bazel \
        build --verbose_failures \
        --distdir=${distDir} \
        --curses=no \
        --sandbox_debug \
        //... \
    '' + lib.optionalString (stdenv.isDarwin) ''
        --cxxopt=-x --cxxopt=c++ --host_cxxopt=-x --host_cxxopt=c++ \
        --linkopt=-stdlib=libc++ --host_linkopt=-stdlib=libc++ \
    '';
  };

in testBazel
