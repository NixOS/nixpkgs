{ lib, fetchFromGitHub, rustPlatform, tree-sitter, difftastic, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "11qvl78dskhawmzjbff2cd4icwvlfhg8hzf1law5w5cr768zv7yn";
  };

  cargoSha256 = "1kmwd9m94kl3j6ajfndr7rjx66fsqvnn2jh0m54ac5qd5r9hhdc8";

  passthru.tests.version = testVersion { package = difftastic; };

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
