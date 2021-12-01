{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-A6Z3g6fbYBynyN4OhRrZNO0ZghvT3XnIahdUQ8SE8tU=";
  };

  cargoSha256 = "sha256-6/JwrPymtpj/CXqx3Pe43v+MJTNONArU2WEo/zgJhT4=";

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
    mainProgram = "difft";
  };
}
