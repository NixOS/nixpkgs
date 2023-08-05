{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+vvlj8gGCHKQ2T245fwaZxCiglRnrDFwupQIh3I47Ys=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-0Qr40hMA59WaHinkUkebF0CwPy3aublgfzSz1er7Uws=";

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
