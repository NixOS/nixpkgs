{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
<<<<<<< HEAD
  version = "2.9.22";
=======
  version = "2.9.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ednQfVG1/A8zliJ6oHXvfjIP7EtAiwdVaUSNUdKwn+g=";
  };

  vendorHash = "sha256-B5za9EcnAytmt0p6oyvXjfeRamsslh+O7n2xMHooLSk=";
=======
    hash = "sha256-tkOhPa163hiuk2sbfhHL6JTD7do3rrDZTkLYvwuue+o=";
  };

  vendorHash = "sha256-OixJhKaPZ58L+eN/cZnsXUPuGhYhFxfMKtqiV/mWLak=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
<<<<<<< HEAD
    mainProgram = "nats-server";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
