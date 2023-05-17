{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V4eNHs+g4uumdRTSMMAKFVcJGHUF/WdT0SScyfUPnC8=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-MxsYJPt7/4UmC5qSbGHyhK1pEDC6yKw189pHnP9BaXM=";

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
