{ lib
, fetchFromGitHub
, buildGoModule
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "mediamtx";
<<<<<<< HEAD
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SKNCQu5uRAxKpQbceha50K4ShV7mE0VI1PGFVAlWq4Q=";
  };

  vendorHash = "sha256-mPnAlFHCJKXOdmKP3Ff7cQJMStKtu4Sa7iYuot5/IKE=";
=======
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NGUEDOME6jzckHrzOboQr5KrZ8Z4iLCTHGCRGhbQThU=";
  };

  vendorHash = "sha256-7+0+F1dW70GXjOzJ/+KTFZPp8o1w2wDvQlX0Zrrx7qU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests need docker
  doCheck = false;

  ldflags = [
<<<<<<< HEAD
    "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}"
  ];

  passthru.tests = { inherit (nixosTests) mediamtx; };

=======
    "-X github.com/aler9/mediamtx/internal/core.version=v${version}"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
=======
    maintainers = with maintainers; [ ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
