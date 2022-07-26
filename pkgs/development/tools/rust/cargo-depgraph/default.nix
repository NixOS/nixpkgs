{ lib, rustPlatform, fetchFromSourcehut }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.2.5";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ewlrxxHnsXBWSMPAlxTfrHj23jMiThkDSJhEsChO/sM=";
  };

  cargoSha256 = "sha256-Ce13vJ5zE63hHVkg/WFdz3LrASj7Xw6nqOO64uALOeQ=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/v${version}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
