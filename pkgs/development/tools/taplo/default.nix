{ lib
, rustPlatform
, fetchCrate
, openssl
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.6.9";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    sha256 = "sha256-gf58V/KIsbM+mCT3SvjZ772cuikS2L81eRb7uy8OPys=";
  };

  cargoSha256 = "sha256-f+jefc3qw4rljmikvrmvZfCCadBKicBs7SMh/mJ4WSs=";

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
