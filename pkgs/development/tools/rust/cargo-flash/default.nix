{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, pkg-config
, rustfmt
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bd0TY8bdpLHLCdDQgJeJvqjAcSF67+LGSNx8yafYbys=";
  };

  cargoSha256 = "sha256-bx2N8zP7BmqU6oM/7Nf2i9S1uNWItReQMD59vtG1RKE=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/cargo-flash/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
