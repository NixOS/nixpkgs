{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NmXBD/BEQnAH4ES5SYwf8fInC4k++JX2OIhvusLlmG8=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  useFetchCargoVendor = true;
  cargoHash = "sha256-vWbPpU3SWkS2ayp1Dr3L/GDqtjKx21KXt+vF9ViHKzc=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ereslibre
      shyim
    ];
    platforms = platforms.unix;
  };
}
