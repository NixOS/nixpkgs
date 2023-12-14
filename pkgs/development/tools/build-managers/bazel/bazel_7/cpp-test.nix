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
    export BAZEL_LINKLIBS='-lstdc++:-lm'
    export BAZEL_LINKOPTS='-x:c++'

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
      set -x
      env | grep c..abi
      ${bazel}/bin/bazel build //... \
        --enable_bzlmod \
        --verbose_failures \
        --repository_cache=${mergedDistDir} \
        --action_env=NIX_DEBUG=1 \
        --announce_rc \
        --curses=no \
    '' + lib.optionalString (stdenv.isDarwin) ''
        --repo_env=BAZEL_LINKLIBS \
        --repo_env=BAZEL_LINKOPTS \
        --cxxopt=-x --cxxopt=c++ \
        --host_cxxopt=-x --host_cxxopt=c++ \
        --action_env=NIX_CFLAGS_COMPILE \
        --action_env=NIX_LDFLAGS \
    '' + lib.optionalString (stdenv.isDarwin && Foundation != null) ''
        --linkopt=-Wl,-F${Foundation}/Library/Frameworks \
        --linkopt=-L${darwin.libobjc}/lib \
    '' + ''

    '';
    #'' + lib.optionalString (stdenv.isDarwin) ''
    #    --repo_env=BAZEL_LINKLIBS='-lstdc++:-lm' \
    #'' + lib.optionalString (stdenv.isDarwin) ''
    #    --cxxopt=-x --cxxopt=c++ --host_cxxopt=-x --host_cxxopt=c++ \
    #    --linkopt=-Wl,-lstdc++ --host_linkopt=-Wl,-lstdc++ \
  };

in testBazel
