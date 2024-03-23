{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FdAUcKey3FamMWKKVDCL+ndXC4bBZHo1om9IUeLMZkA=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-+zlRLs/m9ThiBgzKWkIpUIL3jWMz/o+hD0m0Vks4HzY=";

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
