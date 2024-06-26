{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.6.0";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = "cargo-depgraph";
    rev = "v${version}";
    hash = "sha256-yvcKRESX2W1oLmQvkl07iG8+I74qDKsaS3amM4pZU8s=";
  };

  cargoHash = "sha256-OJOw0V4u/bK4vw3bU2wKVeOqP205ehfZMKJ6qIpYDLU=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    mainProgram = "cargo-depgraph";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/${src.rev}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
