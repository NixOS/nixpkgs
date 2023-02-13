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
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YAeE3pDw5xqSn4rAv3lxJtKQHki1bf97CJHBEK8JoiA=";
  };

  cargoSha256 = "sha256-p6d8vdiAVkufTQv3FliKCBgF5ZXM24UnG96EzlpyfZE=";

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
