{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-eEsb88f16Ug9h7JNkzwSTxJZEV5r4XmmzsTxTQGk+j8=";
  };

  cargoHash = "sha256-kcs55NgwsqgZXcx+a6g0o9KdUG4tt0ZBv3dU/Pb0NJk=";

  # Only build the command line client
  cargoBuildFlags = [ "--bin" "subxt" ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC.";
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
