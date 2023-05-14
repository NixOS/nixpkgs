{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EfkN0cKCoe6NA3thCVb2uY664GmQdSitv1yg/DTYtls=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-BT1wslIrCCmehWfs9QuT5/HqKJVq5BkoyfKvUIx2nQw=";

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
