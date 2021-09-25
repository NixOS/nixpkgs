{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, openssl
, pkg-config
, rustfmt
, Security
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yTtnRdDy3wGBe0SlO0165uooWu6ZMhUQw3hdDUK1e8A=";
  };

  cargoSha256 = "sha256-f5vUMdyz3vDh2yE0pMKZiknsqTAKkuvTCtlgb6/gaLc=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 openssl ] ++ lib.optionals stdenv.isDarwin [ Security AppKit ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
