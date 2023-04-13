{ lib
, rustPlatform
, fetchFromGitHub
, libclang
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h9114HFWIsJn95pJ3QoDokNgAkE6KFjDt5Rt85vT7zw=";
  };

  cargoSha256 = "sha256-hYCDpSKi7HlqwdnMnfnKw46VpO+bhsV11kIu/4yMaBw=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  LIBCLANG_PATH = "${libclang.lib}/lib";

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
