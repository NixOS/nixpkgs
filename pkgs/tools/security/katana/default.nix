{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-0OXpA+sa97YjbHhIq3Uj65OWg53PH9y2cY8bjCqC3tQ=";
  };

  vendorHash = "sha256-rb0fNAOP4y2yvJb7FIlAIfXF0uw0eLKgup75f9cwT6U=";
=======
    hash = "sha256-LXyYdfBrqtMN4qGakQDG/axzmDTYkwCun2xw9Heaejk=";
  };

  vendorHash = "sha256-MEmVmokQX/HfBPvObeW1M5L6zm2KXB1yzGmNFBjt+i0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;

  subPackages = [ "cmd/katana" ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
