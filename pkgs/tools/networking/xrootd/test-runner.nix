{
  lib,
  runCommand,
  xrootd,
}:

# These tests are specified in the test procedure of the upstream CD:
# https://github.com/xrootd/xrootd/blob/master/.github/workflows/build.yml#L90-L98
runCommand "${xrootd.pname}-run-tests-${xrootd.version}"
  {
    testRunnerPath = "${xrootd}/bin/test-runner";
    testLibraries = [ "XrdClTests" ];
    XrdClTestsSuites = [
      "UtilsTest"
      "SocketTest"
      "PollerTest"
    ];
    pname = "${xrootd.pname}-run-tests";
    inherit (xrootd) version;
    meta.mainProgram = "test-runner";
  }
  ''
    for testLibrary in $testLibraries; do
      echo "Testing $testLibrary"
      testLibraryPath="${xrootd.out}/lib/lib''${testLibrary}.so"
      testsuiteVarname="''${testLibrary}Suites"
      for testsuite in ''${!testsuiteVarname}; do
        echo "Doing test $testsuite"
        "$testRunnerPath" "$testLibraryPath" "All Tests/$testsuite/"
      done
    done
    mkdir -p "$out/bin"
    ln -s "$testRunnerPath" "$out/bin/test-runner"
  ''
