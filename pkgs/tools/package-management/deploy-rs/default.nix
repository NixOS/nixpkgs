{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "0a0187794ac7f7a1e62cda3dabf8dc041f868790";
    hash = "sha256-dTGGw2y8wvfjr+J9CjQbfdulOq72hUG17HXVNxpH1yE=";
  };

  cargoHash = "sha256-Vo/45cZM/sBAaoikhEwCvduhMQjurwSZwCjwrIQn7IA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "deploy";
  };
}
