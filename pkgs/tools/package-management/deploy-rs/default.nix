{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
<<<<<<< HEAD
  version = "unstable-2023-06-04";
=======
  version = "unstable-2023-05-05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
<<<<<<< HEAD
    rev = "65211db63ba1199f09b4c9f27e5eba5ec50d76ac";
    hash = "sha256-1FldJ059so0X/rScdbIiOlQbjjSNCCTdj2cUr5pHU4A=";
  };

  cargoHash = "sha256-iUYtLH01YGxsDQbSnQrs4jw2eJxsOn2v3HOIfhsZbdQ=";
=======
    rev = "6b0b6a1c2527e8b1ef370a308b6ef8903004ac47";
    hash = "sha256-UUxpb5PMkFfP2JGoPMEUvKbxv+wCkTWy4uZs1MyyCes=";
  };

  cargoHash = "sha256-6/VSfCNBstr+fQPdpMl5b2MwNxRjSJvTDuTGKySPGsk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
<<<<<<< HEAD
    mainProgram = "deploy";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
