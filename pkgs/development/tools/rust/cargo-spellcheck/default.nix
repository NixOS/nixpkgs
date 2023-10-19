{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pJsRY9fDHDQTd0J/gbSzl/JM3kzm8v+w13JRbTYnMFM=";
  };

  cargoHash = "sha256-XDGOhPO09d5nq355LiDBKc5v8dx8RuzGKC2fnFF/M+E=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam matthiasbeyer ];
  };
}
