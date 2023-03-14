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
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Zwb9jUZwkvuBzvACMwKwpAHEMkjLVDkXfDLo4ntG3+k=";
  };

  cargoSha256 = "sha256-giGSTMtGTIw4ZZglHqbW2sGKO/D/3TVQR5olTgitBjE=";

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
