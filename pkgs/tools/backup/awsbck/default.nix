{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-KHbAmx2CsRqatGt5zTvqZSq8fwcClRZkeMHucLAr8bY=";
  };

  cargoHash = "sha256-dMXaIFc0e6PMYiQrokQoUc1xAVCccE92WzM2fl7tOBQ=";

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
