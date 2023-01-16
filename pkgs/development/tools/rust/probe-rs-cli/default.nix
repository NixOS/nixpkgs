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
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-y9EHksRDVbw58XiV7/dKzy4p6OWWAkQ3X9LP/WDWD2c=";
  };

  cargoSha256 = "sha256-vv8XSAsGs1M97Y6cIGYevCdaxmPy3aDmHFF00exumq8=";

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
