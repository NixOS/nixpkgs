{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZzzEKpD32mHn1qae002rtKNEmv2Spf3yvxpYZqHmx/I=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-4Zmgp9QKyxCArQicYJ7/8Rn15wfnYVoiWAA919p3Njo=";

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
