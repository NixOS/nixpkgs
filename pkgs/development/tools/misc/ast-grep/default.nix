{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-gAzO5ganbwxarqHGVhAl9PtiHEr89puoPJK+iXtrvyU=";
  };

  cargoHash = "sha256-SvGxDXC1nN6LitWHGcVieHJpEEuY1omqAvjaJmHPauE=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # disable flaky test
    "--skip=test::test_load_parser_mac"
  ];

  meta = with lib; {
    mainProgram = "sg";
    description = "A fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr lord-valen ];
  };
}
