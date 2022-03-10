{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cl-wordle";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-z2XpXgOviBRcberwpxQ4ml1T04k5kMhG7wA0PAYWENg=";
  };

  cargoSha256 = "sha256-C7UMkhgez2CtddftARlwN1TjZ1N26NnZfpRiX1KkMEA=";

  meta = with lib; {
    description = "Wordle TUI in Rust";
    homepage = "https://github.com/conradludgate/wordle";
    # repo has no license, but crates.io says it's MIT
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "wordle";
  };
}
