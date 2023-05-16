{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
<<<<<<< HEAD
  version = "0.12.13";
=======
  version = "0.12.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tlnj0CCsPZRQjIZCvNPjN0JD6oqRDvdWOCYR3tYMPUA=";
  };

  vendorHash = "sha256-DVJZ35C+6SuhaaGDM3u+3fB1497qaW6oTByAUPVwhJI=";
=======
    hash = "sha256-axiIHy6vNs0ySVP4UnYZ9J+GeAOz3LJ9vOP1xT4dcME=";
  };

  vendorHash = "sha256-kHwCh/6yaPaFce5k3NgAQ1GsoVmvmfIJujVaMwqrLBM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    changelog = "https://github.com/itchyny/gojq/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
<<<<<<< HEAD
    mainProgram = "gojq";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
