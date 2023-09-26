{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ast-grep";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    rev = version;
    hash = "sha256-YxjqzjN+rDgoticiic93+C2dBuhcdLVjtccMnzPepd0=";
  };

  cargoHash = "sha256-TEqTTM/AYLnFaWNrDyQWSjPWhkIehQAm04aCh+HC3LA=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # disable flaky test
    "--skip=test::test_load_parser_mac"

    # BUG: Broke by 0.12.1 update (https://github.com/NixOS/nixpkgs/pull/256548)
    # Please check if this is fixed in future updates of the package
    "--skip=verify::test_case::tests::test_unmatching_id"
  ];

  meta = with lib; {
    mainProgram = "sg";
    description = "A fast and polyglot tool for code searching, linting, rewriting at large scale";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr lord-valen cafkafk ];
  };
}
