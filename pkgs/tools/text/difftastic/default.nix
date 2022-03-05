{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-pZyQnPIdyS8XkzP9KwGKRjF21YWGgCVNeQSie9g5NcE=";
  };

  cargoSha256 = "sha256-VXbCrhoGF6bCzQ02Y1LQkbEVrmIfDIKFWF9vx43tt94=";

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
