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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "151zdnv4i0dgkk4w3j2a1sdklcxw07bgqjs7sv6lvkylrx8dfrxa";
  };

  cargoSha256 = "00p2rwqrax99kwadc8bfq8pbcijals2nzpx43wb03kwxl4955wn9";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 libftdi1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  cargoBuildFlags = [ "--features=ftdi" ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
