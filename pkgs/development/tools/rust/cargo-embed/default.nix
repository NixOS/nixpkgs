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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1is58n8y5lvnvzkbnh3gfk3r3f2r1w4l2qjdp2k8373apxzjxdvr";
  };

  cargoSha256 = "0kalwigck9lf734zdpzg01sf2zzyrgdgq2rg3qj7hy94gfxlsk63";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 libftdi1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  buildFeatures = [ "ftdi" ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/cargo-embed/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
