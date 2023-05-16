<<<<<<< HEAD
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
=======
{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-depgraph";
  version = "1.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-D8g6xsmYvN1IWUFpkpo4/OKT70WqCCkRqcGFBOE8uXA=";
  };

  cargoSha256 = "sha256-qpd/uvnQzrPc+dbBloxyYNCEjaRWlTicgNC8Z9Z0t88=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
<<<<<<< HEAD
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/${src.rev}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/v${version}/item/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
