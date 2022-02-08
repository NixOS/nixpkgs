{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cl-wordle";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-M2ljFrfIOyM1Slwsk7ZJ+PhJIVSUvFcFck2Q2e9nOwc=";
  };

  cargoSha256 = "sha256-bB6MzpJc8QS2+8GSS8RbSF5QcJyRT8FkmChpf1x2i/E=";

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
