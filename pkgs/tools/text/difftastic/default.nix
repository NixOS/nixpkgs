{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-Arg1n5WFCNGHZay56BvLrPDAvvUKVurVNEKgTzHgIzI=";
  };

  cargoSha256 = "sha256-ArIyIAxVgGmI+MdkVBo0xihDdw3RlRiPLJOhPcC1KLw=";

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
