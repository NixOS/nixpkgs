{ lib, rustPlatform, fetchFromSourcehut }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.5.0";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = "cargo-depgraph";
    rev = "v${version}";
    hash = "sha256-q9a7O6lSsQz9nJ82uG1oNyNyNebzXEanVWh3xkypqqM=";
  };

  cargoHash = "sha256-gmSNYxyizaVvz38R0nTdUp9nP/f4hxgHO9hVV3RFP6U=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    mainProgram = "cargo-depgraph";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/${src.rev}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
