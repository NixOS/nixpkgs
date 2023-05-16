{ lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
=======
, libclang
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-XqT2l839fRDNj6zJB0vlVMmoRB2Lz61cN297PNIvFX8=";
  };

  cargoSha256 = "sha256-PzPQnexT1oeZ0FkTLyZiQJlMx+WDoSHD+J1JzoME6sA=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optional stdenv.isDarwin Security;

=======
    sha256 = "sha256-h9114HFWIsJn95pJ3QoDokNgAkE6KFjDt5Rt85vT7zw=";
  };

  cargoSha256 = "sha256-hYCDpSKi7HlqwdnMnfnKw46VpO+bhsV11kIu/4yMaBw=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  LIBCLANG_PATH = "${libclang.lib}/lib";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ newam matthiasbeyer ];
=======
    maintainers = with maintainers; [ newam ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
