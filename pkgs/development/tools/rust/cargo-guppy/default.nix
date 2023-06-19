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
  version = "unstable-2023-06-19";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "23b1c804cb4a6d9d38d093ca3400e90805d4c36c";
    sha256 = "sha256-cKnu28L8tjndjtHuClLIpiwTzf6YoN37vw1sE7xrNzQ=";
  };

  cargoSha256 = "sha256-fCIBv8FOUBPzf7I7CdVBDvbHVyuNQRURxNQ7B7cgoKE=";

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
