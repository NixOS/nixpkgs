{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "autocorrect";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-njgngDowyRfOY9+BnBSNWow5GkdGhRu2YPXkA6n23qE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoBuildFlags = [ "-p" "autocorrect-cli" ];
  cargoTestFlags = [ "-p" "autocorrect-cli" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A linter and formatter for help you improve copywriting, to correct spaces, punctuations between CJK (Chinese, Japanese, Korean)";
    homepage = "https://huacnlee.github.io/autocorrect";
    changelog = "https://github.com/huacnlee/autocorrect/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [];
  };
}
