{ stdenv, writeText, runCommandCC, bazel }:

# Tests that certain executables are available in bazel-executed bash shells.

let
  WORKSPACE = writeText "WORKSPACE" ''
    workspace(name = "our_workspace")
  '';

  fileIn = writeText "input.txt" ''
  one
  two
  three
  '';

  fileBUILD = writeText "BUILD" ''
    genrule(
      name = "tool_usage",
      srcs = [ ":input.txt" ],
      outs = [ "output.txt" ],
      cmd = "cat $(location :input.txt) | gzip - | gunzip - | awk '/t/' > $@",
    )
  '';

  runLocal = name: script: runCommandCC name { preferLocalBuild = true; } script;

  workspaceDir = runLocal "our_workspace" ''
    mkdir $out
    cp ${WORKSPACE} $out/WORKSPACE
    cp ${fileIn} $out/input.txt
    cp ${fileBUILD} $out/BUILD
  '';

  testBazel = runLocal "bazel-test-bash-tools" ''
    export HOME=$(mktemp -d)
    cp -r ${workspaceDir} wd && chmod +w wd && cd wd
    ${bazel}/bin/bazel build :tool_usage
    cp bazel-genfiles/output.txt $out
    echo "Testing content" && [ "$(cat $out | wc -l)" == "2" ] && echo "OK"
  '';

in testBazel
