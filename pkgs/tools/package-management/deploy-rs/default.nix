{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2023-05-05";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "6b0b6a1c2527e8b1ef370a308b6ef8903004ac47";
    hash = "sha256-UUxpb5PMkFfP2JGoPMEUvKbxv+wCkTWy4uZs1MyyCes=";
  };

  cargoHash = "sha256-6/VSfCNBstr+fQPdpMl5b2MwNxRjSJvTDuTGKySPGsk=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
