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
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IjeQPsHDHmKmS0UeivgmM8dQyhwak1PBIBw31KlVu64=";
  };

  cargoHash = "sha256-BkYidZzqiI7EIgEuYbeGC7qeVvhC1GARFC4EZpDdBmg=";

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
