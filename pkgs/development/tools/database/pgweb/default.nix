{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pgweb";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0wwDye7Iku9+brYoVqlCpnm+A3xsr8tL2dyWaBVvres=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorHash = "sha256-Jpvf6cST3kBvYzCQLoJ1fijUC/hP1ouptd2bQZ1J/Lo=";

  ldflags = [ "-s" "-w" ];

  checkFlags =
    let
      skippedTests = [
        # There is a `/tmp/foo` file on the test machine causing the test case to fail on macOS
        "TestParseOptions"
      ];
    in
    [ "-skip" "${builtins.concatStringsSep "|" skippedTests}" ];

  meta = with lib; {
    description = "A web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb/";
    license = licenses.mit;
    maintainers = with maintainers; [ zupo luisnquin ];
  };
}
