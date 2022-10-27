{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mlbS9EI/ltxnWfpci9hK9QwYpA/nII+wc2IRSHrmNGI=";
  };

  cargoSha256 = "sha256-9CKFZmkFiip6iQVkBmy/XoMEoyMhlKNRyI8oDHaAILc=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/v${version}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
