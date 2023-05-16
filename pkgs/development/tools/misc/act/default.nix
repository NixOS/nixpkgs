{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
<<<<<<< HEAD
  version = "0.2.50";
=======
  version = "0.2.45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-NVzONabM1EUsA+PUyJ7hBOZmqs5RYfE0teNO6BMBu7M=";
  };

  vendorHash = "sha256-+MQofGGja4JUSWCctY0CWQ2aYpVrXj4/knqd/TW0PtI=";
=======
    hash = "sha256-mp5+hDSZsp46WMCCqVoorKSHeoQY/+ORtj0fNrKsFWI=";
  };

  vendorHash = "sha256-37fHVy4NLhWyk1yD9zSNnZoVVyd2QizzDCDbiNJCBlc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
=======
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
