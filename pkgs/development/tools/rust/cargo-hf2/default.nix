{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libusb1
, stdenv
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hf2";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0o3j7YfgNNnfbrv9Gppo24DqYlDCxhtsJHIhAV214DU=";
  };

  cargoHash = "sha256-zBxvpQfB9xw8+Rc1H1EaK/gQZtQ+uSs4YJwhm2o0vhI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "Cargo Subcommand for Microsoft HID Flashing Library for UF2 Bootloaders";
    mainProgram = "cargo-hf2";
    homepage = "https://lib.rs/crates/cargo-hf2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ astrobeastie ];
  };
}
