{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-guppy";
  version = "unstable-2024-07-29";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "37e651b65d0d2bbdbccf06376b4b968b1f9ff926";
    sha256 = "sha256-2CVdSXP1attUxP1ruRdMVb1vKGnr8da7kguWm0sDPcA=";
  };

  cargoHash = "sha256-jtBUCXLjZhEQF/D6xuSp/41ADkAxFcHaMAvWVTkqEPk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p" "cargo-guppy" ];
  cargoTestFlags = [ "-p" "cargo-guppy" ];

  meta = with lib; {
    description = "Command-line frontend for guppy";
    mainProgram = "cargo-guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
