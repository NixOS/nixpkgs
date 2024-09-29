{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-risczero";
  version = "1.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mFzQxDCUYpdZKsXHsBBxKDbOLnabDmLcPFs/lLtoiV8=";
  };

  cargoHash = "sha256-2OJRyiJD5ZjdoqAGkFEkArsylXZwoS5qOGhiPE1VjMw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Cargo extension to help create, manage, and test RISC Zero projects";
    mainProgram = "cargo-risczero";
    homepage = "https://risczero.com";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
