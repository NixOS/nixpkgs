{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, pkgconfig, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "cargo-edit-${version}";
  version = "0.3.0-beta.1";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    sha256 = "0a6gg940jqnxp7yypgf7qcv9071dsxy9h8mzpfkkk8pa1m2lp4q7";
  };

  buildInputs = [ pkgconfig openssl ];

  cargoSha256 = "169lx50nspv2hmmg3r03bda2nbmn2f6k0f6ps8l8jbqja6cjz4sr";

  meta = with stdenv.lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jb55 jD91mZM2 ];
    platforms = platforms.all;
  };
}
