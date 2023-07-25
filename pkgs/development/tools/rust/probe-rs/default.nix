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
  version = "0.19.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SPfCZil56UMr1Gy9pPZyngT0sHMQJrcE4KcjLvTD4js=";
  };

  cargoHash = "sha256-QEOlsKnCMpm4L2Y1Byqntxjgg3zQFYCGkkwFRqmqx0I=";

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
