{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, libusb1
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "rtthost";
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-h/D2LW8tQ2WfVrP+HOLs3Gg7HS2Rd0zXBxbnxvEeiWk=";
  };

  cargoHash = "sha256-cEzp33y1wuOrKHJBdAPxWUc1ANpT7Sg1MZmaCno1WKA=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "RTT (Real-Time Transfer) client";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ samueltardieu ];
  };
}
