{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tJLx/dts7C5yupJX2jkRiAQumlPtlg2HzFx11jQczzE=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-LMdi1Xx6Tq8q+DQHpNDwmtQO+8hiVXjEP7fDIpbN2DU=";

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
