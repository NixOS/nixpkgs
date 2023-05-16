{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
<<<<<<< HEAD
  version = "2.17.0";
=======
  version = "2.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cVW0CsVEBitSXS1Ciyt/EhE38KM7x4Up3aYUwKwrxvg=";
  };

  vendorHash = "sha256-mxSfdkqwJBUu34VWQ2Xlb2Jbz1QgWUH78Xngge9+AfA=";
=======
    sha256 = "sha256-GB+BAGIVPtyY2Bsm/yDTYjJixLGvGwsIoOLCyy/0AJk=";
  };

  vendorHash = "sha256-5LIIXf+8ZN7WcFSPzsJ5Tt+d40AgF5YI3O1oXms1WgI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
<<<<<<< HEAD
=======
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
