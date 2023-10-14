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
  pname = "probe-rs";
  version = "0.21.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-UmQwz9Ejb5+epwGKsglV3QdWGqOEH/3DRqvKtfm14kg=";
  };

  cargoHash = "sha256-awa84xvIRrEhuPm4N2xt5bsYy2wbLjJokrKoAxCYvR4=";

  cargoBuildFlags = [ "--features=cli" ];

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
