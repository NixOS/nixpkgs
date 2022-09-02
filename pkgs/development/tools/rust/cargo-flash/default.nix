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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O6T1Wul0nJaTVp9MEOj9FT+FUt4oYfqR5pGFaAxuK30=";
  };

  cargoSha256 = "sha256-E2gBkr50hjkzY+ZVgMm7tpdwr9yuyFh65Ht6FAPvxYg=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/cargo-flash/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker newam ];
  };
}
