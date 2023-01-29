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
  version = "0.14.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-CrBgj0M3slhPrAYc2+I80ZfUC/CJzcmFwLc9yX2SSR4=";
  };

  cargoSha256 = "sha256-nHjVldLsi9Xr6pPOeLpb6anvno2244g/LNIv7DnbSI4=";

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
