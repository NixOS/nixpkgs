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
  version = "unstable-2022-10-29";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "448d830de4867c32eaa57911a392e47c81d1a0e0";
    sha256 = "sha256-Ce6WO01gN8Ip5smAyGNEg87vyFXFDIq6ilHTbEStm/c=";
  };

  cargoSha256 = "sha256-DR/k6g2uWCOhM20qROybsH4gTvH+Kd+jaDHGZ4loK7g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p" "cargo-guppy" ];
  cargoTestFlags = [ "-p" "cargo-guppy" ];

  meta = with lib; {
    description = "A command-line frontend for guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
