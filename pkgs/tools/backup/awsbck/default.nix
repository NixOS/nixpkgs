{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-qW8UY+klNqzDcfVVCW1O7EARFdgLmnf7g/WcYNfT1SI=";
  };

  cargoHash = "sha256-T/xzhE1XXexyT5ktDxny68zaszEhqKfSmibjs6T2B2E=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  # tests run in CI on the source repo
  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ beeb ];
    mainProgram = "awsbck";
  };
}
