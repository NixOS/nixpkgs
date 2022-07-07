{ lib, rustPlatform, fetchCrate, stdenv, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-vz3ClC2PI0ti+cItuVdJgP8KLmR2C+uGUzl3DfVuTrY=";
  };

  cargoSha256 = "sha256-m6wsca/muGPs58myQH7ZLPPM+eGP+GL2sC5suu+vWU0=";

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
