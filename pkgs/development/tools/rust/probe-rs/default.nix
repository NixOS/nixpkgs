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
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3L4dvEIPxbNYh+Z5G1iccqLLYi13RTRaFnOD4U/zNtE=";
  };

  cargoHash = "sha256-peCXG9TrsnBqQOy+pgRNGstn0bwKNCdWQ3Jn5r0fcOI=";

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
