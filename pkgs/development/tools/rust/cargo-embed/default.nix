{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, libftdi1
, pkg-config
, rustfmt
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-embed";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UlQ7KJmzPWu0vVsYPIkYeqkFFhxe7mEMfUVN7iMaUw0=";
  };

  cargoSha256 = "sha256-RkYX5z764Kkr0xK7yYQ0lCw0/7KpmdJmKWqLzwkj4hs=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 libftdi1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  buildFeatures = [ "ftdi" ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/cargo-embed/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker newam ];
  };
}
