{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-6gKskJbKo1mVVRzojfGuGTsGCV/r+8hw7r1v4ufSa+A=";
  };

  cargoHash = "sha256-5Xj/V9XKd5neNZh9LaFrQ48Us42+e2f5UhMNA1RaQSE=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = lib.optionals (stdenv.isx86_64 && stdenv.isDarwin) [
    # fails on emulated x86_64-darwin
    # mach-o file, but is an incompatible architecture (have 'arm64', need 'x86_64')
    "--skip=test::test_load_parser"
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
