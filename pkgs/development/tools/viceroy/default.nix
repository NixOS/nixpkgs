{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/B07J1VVrg8kqvJSEWaWbvAu1/3Xr4g1j4uLjuUdCh8=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-k/BYHbZb0lfHDSXXApcM/BiAJByeH3dwrn71i9b8Aqs=";

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
