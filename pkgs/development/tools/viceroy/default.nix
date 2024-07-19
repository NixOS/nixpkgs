{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B6+ooPsKSsZNVyf9ObRM+iXYCsev3hztst4lU2z1p7A=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-vu/x5SAHUx/L/gBQ22spXHHpc39E+Eg7olFNRimVB2s=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}
