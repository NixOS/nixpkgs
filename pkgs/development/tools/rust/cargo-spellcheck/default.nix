{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XqT2l839fRDNj6zJB0vlVMmoRB2Lz61cN297PNIvFX8=";
  };

  cargoSha256 = "sha256-PzPQnexT1oeZ0FkTLyZiQJlMx+WDoSHD+J1JzoME6sA=";

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
