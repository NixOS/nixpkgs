{ writeText, bazel, runLocal, bazelTest, distDir, extraBazelArgs ? ""}:

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

  workspaceDir = runLocal "our_workspace" {} ''
    mkdir $out
    cp ${WORKSPACE} $out/WORKSPACE
    cp ${fileIn} $out/input.txt
    cp ${fileBUILD} $out/BUILD
  '';

  testBazel = bazelTest {
    name = "bazel-test-bash-tools";
    bazelPkg = bazel;
    inherit workspaceDir;

    bazelScript = ''
      ${bazel}/bin/bazel build :tool_usage --distdir=${distDir} ${extraBazelArgs}
      cp bazel-bin/output.txt $out
      echo "Testing content" && [ "$(cat $out | wc -l)" == "2" ] && echo "OK"
    '';
  };

in testBazel
