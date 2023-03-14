{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X+RmsS+GxdBiFt2Fo0MgkuyjQDwQNuOLDL1YVQdqhXo=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-vbhBlfHrFcjtaUJHYvB106ElYP0NquOo+rgIx9cWenY=";

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
