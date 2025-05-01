{ lib, rustPlatform, fetchgit }:

rustPlatform.buildRustPackage rec {
  pname = "rustHelloWorld";
  version = "0.1.0";

  src = fetchgit {
    url = "https://codeberg.org/Hypernova/rust-hello-world.git";
    rev = "d16d8c4eb24d6fb396973706e2bda0e7251debad";
    hash = "sha256-QRlPCqqvr3rsoBeUmJ+9Jwbo4lzKR9NbleEgMniXpVs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-85vDANDbjgG15DVnZI6kGfl30FWLruo7r/a4maO4ZFY=";

  meta = with lib; {
    description = "A minimal Rust hello world binary";
    homepage = "https://codeberg.org/Hypernova/rust-hello-world";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "rust-hello-world";
  };
}
