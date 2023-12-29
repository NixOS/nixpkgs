{ lib, fetchFromGitHub, rustPlatform, testers, ttags }:
let version = "0.3.0";
in rustPlatform.buildRustPackage {
  pname = "ttags";
  inherit version;

  src = fetchFromGitHub {
    owner = "npezza93";
    repo = "ttags";
    rev = "${version}";
    hash = "sha256-yqrCcA/+FyGPpX3hhULiwhMfrDWjq+rzT04M+o9ry5s=";
  };

  cargoHash = "sha256-jW3xIlo2cN5aoEUp3FxN4pwGFvlg50i5RMNgQopGb88=";

  passthru.tests.version = testers.testVersion {
    package = ttags;
    command = "ttags --version";
    version = version;
  };

  meta = with lib; {
    description = "Generate tags using tree-sitter";
    longDescription = ''
      ttags generates tags (similar to ctags) for various
      languages, using tree-sitter.

      Can be run as a language server that updates the tags
      for a file when it is saved.

      Supported languages:
      - Haskell
      - JavaScript
      - Nix
      - Ruby
      - Rust
      - Swift
    '';
    homepage = "https://github.com/npezza93/ttags";
    license = licenses.mit;
    maintainers = with maintainers; [ mrcjkb ];
    platforms = platforms.all;
  };
}
