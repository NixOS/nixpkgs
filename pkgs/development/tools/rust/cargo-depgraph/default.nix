{ lib, rustPlatform, fetchFromSourcehut }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.2.2";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Zt60F43hhFSj9zfAkEbgRqODvBRmzn04dHMijbz+uX0=";
  };

  cargoSha256 = "sha256-mMXIiAfYBqOS3z4735T9dB9TEo7Ph2JCNq0QfyetxJg=";

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/v${version}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
