{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ml9N4oxq80A1y7oFE98eifFIEtdcT9IRhXwDMEJ298k=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-PC2StxMefsiKaY9fXIG4167G9SoWlbmJBDGwrFBa4os=";

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
