{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Z5poizMXp4xgn0Tx0E36rvueBx3dFL7++alewqG9E9w=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-EbvEclXwQgNIYQ/ppbZGhT4v4rMSpreURg2OYhQ7dRI=";

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
