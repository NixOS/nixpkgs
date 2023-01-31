{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, libusb1
, openssl
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs-cli";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YNOD0hDDQ6M496m9lps28UX41pMO1r/CE30rcS53h48=";
  };

  cargoSha256 = "sha256-/1bnDtfNxnOI4Inmnd+r2epT236ghQsiNuoAuROEfPM=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 openssl ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ xgroleau newam ];
  };
}
