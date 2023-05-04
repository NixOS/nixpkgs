{ lib
, stdenv
, rustPlatform
, fetchCrate
, libusb1
, libftdi1
, pkg-config
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-embed";
  version = "0.18.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Z8PoM1zlbTYH1oF9nHzu3QykHQ+IXewrXAOieLguFuQ=";
  };

  cargoHash = "sha256-xL1QbeOLnAJVcBdp2NIMlT5LMxkNwA99VzCHV9NjwUo=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 libftdi1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  buildFeatures = [ "ftdi" ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/cargo-embed/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker newam ];
  };
}
