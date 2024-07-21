{
  bazel
, bazelTest
, stdenv
, darwin
, extraBazelArgs ? ""
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

  WORKSPACE = writeText "WORKSPACE" ''
    workspace(name = "our_workspace")
  '';

  pythonLib = writeText "lib.py" ''
    def foo():
      return 43
  '';

  pythonBin = writeText "bin.py" ''
    from lib import foo

    assert foo() == 43
  '';

  pythonBUILD = writeText "BUILD" ''
    py_library(
      name = "lib",
      srcs = [ "lib.py" ],
    )

    py_binary(
      name = "bin",
      srcs = [ "bin.py" ],
      imports = [ "." ],
      deps = [ ":lib" ],
    )
  '';

  workspaceDir = runLocal "our_workspace" {} (''
    mkdir $out
    cp ${WORKSPACE} $out/WORKSPACE
    mkdir $out/python
    cp ${pythonLib} $out/python/lib.py
    cp ${pythonBin} $out/python/bin.py
    cp ${pythonBUILD} $out/python/BUILD.bazel
  ''
  + (lib.optionalString stdenv.isDarwin ''
    mkdir $out/tools
    cp ${toolsBazel} $out/tools/bazel
  ''));

  testBazel = bazelTest {
    name = "${bazel.pname}-test-builtin-rules";
    inherit workspaceDir;
    bazelPkg = bazel;
    bazelScript = ''
      ${bazel}/bin/bazel \
        run \
        --distdir=${distDir} \
        ${extraBazelArgs} \
        //python:bin
    '';
  };

in testBazel
