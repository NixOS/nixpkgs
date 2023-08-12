{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-Il7VJyp4iIo8KrFHRoE4QptgzlJGKr+Npp2IkjDx/vc=";
  };

  cargoHash = "sha256-KReLBqdXtef20tULasw47wrm5k+qUBwo8tPiOTvD9cQ=";

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
