{ lib, fetchFromGitHub, rustPlatform, tree-sitter, difftastic, testers }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-jdkyDsuOOG1dJmgRmMp2KhY9ermccjrxK2JAIzpO6nw=";
  };

  cargoSha256 = "sha256-qHG3ve8HoMWBS/x6mRbXMsrpcqNqfVcbAkfYOk7Su/0=";

  passthru.tests.version = testers.testVersion { package = difftastic; };

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
