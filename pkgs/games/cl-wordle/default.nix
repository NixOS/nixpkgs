{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cl-wordle";
  version = "0.1.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mcPC2Lj+Vsytfl3+ghYn74QRfM6U4dQLUybtCqkjKlk=";
  };

  cargoSha256 = "sha256-3Ef8gLFWIAYpKdPixvILvDee5Gezh68hc9TR5+zRX0I=";

  patches = [ ./rust-1-57.diff ];

  meta = with lib; {
    description = "Wordle TUI in Rust";
    homepage = "https://github.com/conradludgate/wordle";
    # repo has no license, but crates.io says it's MIT
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "wordle";
  };
}
