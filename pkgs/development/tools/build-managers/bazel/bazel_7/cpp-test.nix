{
  bazel
, bazel-examples
, bazelTest
, callPackage
, darwin
, distDir
, extraBazelArgs ? ""
, Foundation ? null
, lib
, runLocal
, runtimeShell
, stdenv
, symlinkJoin
, writeScript
, writeText
}:

let

  localDistDir = callPackage ./bazel-repository-cache.nix {
    lockfile = ./cpp-test-MODULE.bazel.lock;

    # Take all the rules_ deps, bazel_ deps and their transitive dependencies,
    # but none of the platform-specific binaries, as they are large and useless.
    requiredDepNamePredicate = name:
      null == builtins.match ".*(macos|osx|linux|win|apple|android|maven).*" name
      && null != builtins.match "(platforms|com_google_|protobuf|rules_|bazel_).*" name ;
  };

  mergedDistDir = symlinkJoin {
    name = "mergedDistDir";
    paths = [ localDistDir distDir ];
  };

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
    cp ${./cpp-test-MODULE.bazel} $out/MODULE.bazel
    cp ${./cpp-test-MODULE.bazel.lock} $out/MODULE.bazel.lock
    echo > $out/WORSPACE
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
      ${bazel}/bin/bazel build //... \
        --enable_bzlmod \
        --verbose_failures \
        --repository_cache=${mergedDistDir} \
        --curses=no \
    '' + lib.optionalString (stdenv.isDarwin) ''
        --cxxopt=-x --cxxopt=c++ \
        --host_cxxopt=-x --host_cxxopt=c++ \
    '' + lib.optionalString (stdenv.cc.isClang && stdenv ? cc.libcxx.cxxabi.libName) ''
        --linkopt=-Wl,-l${stdenv.cc.libcxx.cxxabi.libName} \
        --linkopt=-L${stdenv.cc.libcxx.cxxabi}/lib \
        --host_linkopt=-Wl,-l${stdenv.cc.libcxx.cxxabi.libName} \
        --host_linkopt=-L${stdenv.cc.libcxx.cxxabi}/lib \
    '' + lib.optionalString (stdenv.isDarwin && Foundation != null) ''
        --linkopt=-Wl,-F${Foundation}/Library/Frameworks \
        --linkopt=-L${darwin.libobjc}/lib \
    '' + ''

    '';
  };

in testBazel
