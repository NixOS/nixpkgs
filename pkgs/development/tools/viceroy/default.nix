{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OWvWi3mIgcWTnRMsnKgYqB9qzICBOmCcWenTfqhaz+k=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-WwhoKHWZSOcocpqPqmSFYzNKxxXtpKpRreaPHqc+/40=";

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
