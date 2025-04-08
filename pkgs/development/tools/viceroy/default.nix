{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mx6zqSuSePvBf7AL807+CzhST5wpmGuuRgFYvhD08Vo=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  useFetchCargoVendor = true;
  cargoHash = "sha256-jW7iWe3hYNeEv5kagTQQK4GIgQQ/mbLhL1cxGJtn9n8=";

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
