{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vMyNsLXMJk8MTiZYRiGQpOLZfeJbKlYcG1U8xTQIty0=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-+v2P9ISSA7Xy5fTjfVNETAStPo19dLxv5K57MC/GU4E=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}
