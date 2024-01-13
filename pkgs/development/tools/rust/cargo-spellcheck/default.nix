{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PgV+sjCf4O24v0i9P7RJIcn28OWMUcPSwy+P5n8RwS4=";
  };

  cargoHash = "sha256-6dhM+FzuLtKtRp2mpE9nlpT+0PBcgGqvBa9vqs6Rs7s=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

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
