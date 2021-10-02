{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "12fcfwx56phs64yl94al2hkvss1km4n9wbrn2md7wfh1137jykbg";
  };

  cargoSha256 = "0xnlnkdvsd2l7acdrkz918cjkk36k01rvvm0c8hnpx5327v6nsa8";

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
