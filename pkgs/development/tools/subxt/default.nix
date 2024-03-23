{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-1SkAYJ6YdZeaD3c1pekd/nwTEI9Zt/2fmA3Y7PPLxoE=";
  };

  cargoHash = "sha256-a3LPvPCQklmrtC9XpxARgYeL4bmj2vFsLbiRGjNUGio=";

  # Only build the command line client
  cargoBuildFlags = [ "--bin" "subxt" ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC.";
    mainProgram = "subxt";
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
