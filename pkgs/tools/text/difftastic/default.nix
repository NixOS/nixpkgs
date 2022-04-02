{ lib, fetchFromGitHub, rustPlatform, tree-sitter }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "sha256-Yp0WwzGo8nuRZuiHdUPxPM1SYBeeVA3SMDfHnQmqUqY=";
  };

  cargoSha256 = "sha256-m80PT2UQYhA5KEh7ax/fhh6vuse0DXhbFsh2x4pwkWY=";

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/raw/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
