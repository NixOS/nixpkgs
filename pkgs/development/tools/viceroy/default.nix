{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T0i0vgwWupCc6C1Cn+Mwo+5CsTmmjD6F6nzsIuOZr/M=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-+CNsChYJU5ut9y7JlqhWZH9VuGwnrxZMguROFtdjFMU=";

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
