{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = "v${version}";
    hash = "sha256-4bslw+BADUQO9cUCEYZ1U4eRdr/2652Shty+NVY0ZYI=";
  };

  cargoHash = "sha256-ed6hc7MIo/Hu1JY7yy6dYHbaTZ9S+T0dh/2H3sTT52Y=";

  meta = with lib; {
    mainProgram = "sg";
    description = "A fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr ];
  };
}
