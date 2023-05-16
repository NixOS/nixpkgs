{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pgweb";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0wwDye7Iku9+brYoVqlCpnm+A3xsr8tL2dyWaBVvres=";
=======
    sha256 = "sha256-+sU+kNTOv78g4mvynXoIyNtmeIDxzfAs4Kr/Lx9zfiU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

<<<<<<< HEAD
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

=======
  vendorSha256 = "sha256-W+Vybea4oppD4BHRqcyouQL79cF+y+sONY9MRggti20=";

  ldflags = [ "-s" "-w" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ zupo luisnquin ];
=======
    maintainers = with maintainers; [ zupo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
