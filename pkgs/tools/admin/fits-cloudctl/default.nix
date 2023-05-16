{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
<<<<<<< HEAD
  version = "0.11.13";
=======
  version = "0.11.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-S4XouqqIBalXqfznrJ8F2TxU9h+gqObnjRXEQnj67LQ=";
  };

  vendorHash = "sha256-Y1F+7bJwsUb09xTSRSdfa6bOPMFCkNBaNurrfB9IPCA=";
=======
    sha256 = "sha256-wsv1d7CdrZeAOgY0a0L1ZjSJVahtfDsOzKaz3Uu2RWM=";
  };

  vendorHash = "sha256-/lDhvmeeEiXP+mihrz6076Cm/29UeJ0QH9GW3hIHKB8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
