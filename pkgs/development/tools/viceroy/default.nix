{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oPeHu/EVcGFE7sSwmMWHnT+xAxayZlfyIk/sM64Q+Hw=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-z24qvgej2bWq0T4OgRnALJda4xGf5/s1O4ij2igCeyU=";

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
