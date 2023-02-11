{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "toml2nix";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YhluLS4tFMibFrDzgIvNtfjM5dAqJQvygeZocKn3+Jg=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A tool to convert TOML files to Nix expressions";
    homepage = "https://crates.io/crates/toml2nix";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
