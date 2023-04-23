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
  version = "0.18.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RCcl0cZhGOKdwlNY7wuCBP0AgoNSU3c/LfCM2pPjsoo=";
  };

  cargoHash = "sha256-NGwWmqP4D5LdXTwo+B+cj+i66Ec9fB723h2kggugLgg=";

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
