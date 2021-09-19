{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-spncRJjROytGnIig6ujqHu0e/XBTN4dsJ3og4aIu+l8=";
  };

  cargoSha256 = "sha256-2xGwS4wjLQ7zmfZ2gMdlUAkjPDF6SmUaiX2j1KYy0vo=";

  postPatch = ''
    pushd vendor
    for grammar in */; do
      if [ -d "${tree-sitter.grammars}/$grammar" ]; then
        rm -r "$grammar"
        ln -s "${tree-sitter.grammars}/$grammar"
      fi
    done
    popd
  '';

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
  };
}
