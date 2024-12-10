{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NrtPV2bd9BuA1nnniIcth85gJQmFGy9LHdajqmW8j4Q=";
  };

  cargoHash = "sha256-mxx4G77ldPfVorNa1LGTcA0Idwmrcl8S/ze+UUoLHhI=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    mainProgram = "cargo-spellcheck";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      newam
      matthiasbeyer
    ];
  };
}
