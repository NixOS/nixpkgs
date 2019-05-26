{ stdenv, lib, writeText, runCommandCC, bazel }:

let
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

    py_test(
      name = "bin",
      srcs = [ "bin.py" ],
      deps = [ ":lib" ],
    )
  '';

  runLocal = name: script: runCommandCC name { preferLocalBuild = true; } script;

  workspaceDir = runLocal "our_workspace" ''
    mkdir $out
    cp ${WORKSPACE} $out/WORKSPACE
    mkdir $out/python
    cp ${pythonLib} $out/python/lib.py
    cp ${pythonBin} $out/python/bin.py
    cp ${pythonBUILD} $out/python/BUILD.bazel
  '';

  testBazel = runLocal "bazel-test-builtin-rules" ''
    export HOME=$(mktemp -d)
    # Note https://github.com/bazelbuild/bazel/issues/5763#issuecomment-456374609
    # about why to create a subdir for the workspace.
    cp -r ${workspaceDir} wd && chmod u+w wd && cd wd
    ${bazel}/bin/bazel \
      test \
        --test_output=errors \
        --host_javabase='@local_jdk//:jdk' \
        //...

    touch $out
  '';

in testBazel
