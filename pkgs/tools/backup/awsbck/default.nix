{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-dUBuuFl6PVTsPnrH9OU3N/GwgTC2/QtH6yKtv3QgBsA=";
  };

  cargoHash = "sha256-X5lYplBej+ZBLnNoHQTGu63pwouGfbVtSH4bgdoxqUo=";

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
