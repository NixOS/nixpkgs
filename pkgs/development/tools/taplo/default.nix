{ lib
, rustPlatform
, fetchCrate
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.7.0";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    sha256 = "sha256-lJdDr6pXOxndv3mBAbqkDnVXOFklSMcnzTed0U1Nm9U=";
  };

  cargoSha256 = "sha256-1wN43HOyrSFTs9nKxUi3kcnGvtONW8SgKwIEK1ckCgk=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
