{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, pkg-config
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hf2";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "jacobrosenthal";
    repo = "hf2-rs";
    rev = "v${version}";
    sha256 = "1vkmdmc2041h7msygqb97zcl8vdxjqwy7w0lvbnw99h693q3hqa0";
  };

  cargoPatches = [
    ./add-cargo-lock.patch
  ];

  cargoSha256 = "sha256-5aTqiJ23XuY9MNIt3lVMIJ+33BZkcS02HbctIJrnEfo=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Cargo Subcommand for Microsoft HID Flashing Library for UF2 Bootloaders ";
    homepage = "https://lib.rs/crates/cargo-hf2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ astrobeastie ];
  };
}
