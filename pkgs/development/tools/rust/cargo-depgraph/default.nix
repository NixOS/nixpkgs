{ lib, rustPlatform, fetchFromSourcehut }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.2.4";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EbAV2VM73K0KiEKcy9kkK1TQHFQ1jRmKG3Tn9GAsWIk=";
  };

  cargoSha256 = "sha256-AAZlAYhl62c8nFvFtwwGniGbQqXu2vHTO4++O1VJ4LM=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/v${version}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
