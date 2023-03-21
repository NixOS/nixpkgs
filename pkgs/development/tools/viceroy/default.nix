{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6D+P7fQBhLYuAw9bIVgEU4Zi18kBLUn/4jr1E8cFugU=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-URBtmMR61K1/LtIt3Q3tfQ4viZPvoiumR2LudcpYk6s=";

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
