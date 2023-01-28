{ lib
, stdenv
, rustPlatform
, fetchCrate
, libusb1
, pkg-config
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.14.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-7sWfMFFjFUdnoMV1O8mzyHAAS8Pvvf1xsY717ZeD7i8=";
  };

  cargoSha256 = "sha256-yae+hh2jrQn6ryn/WPFZmiZrq7d+osegD/MyBk8OOLg=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/cargo-flash/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker newam ];
  };
}
