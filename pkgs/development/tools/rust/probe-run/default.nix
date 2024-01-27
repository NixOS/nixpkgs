{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, DarwinTools
, libusb1
, libiconv
, AppKit
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PIUL7aUIHyHuetkMbJsZ3x1coyzKGwI/AJE/R6uFBM4=";
  };

  cargoHash = "sha256-7q5M3huI7Qje5E3Rl2i/9I4g90R8vhJD9Hk78biewBE=";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    DarwinTools
  ];

  buildInputs = [
    libusb1
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    AppKit
    IOKit
  ];

  meta = with lib; {
    description = "Run embedded programs just like native ones";
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear newam ];
  };
}
