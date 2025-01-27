{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X2cuJH6MzcA/eEGPVxdMbYkrX3o28i0wR6DP0skf2+o=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  useFetchCargoVendor = true;
  cargoHash = "sha256-UrfxNjKOHQCYKMr83W7XSpQIYxnZkCgIWfp/YtTKpIc=";

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
