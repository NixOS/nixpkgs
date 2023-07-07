{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-4iFPHMCWKOfwqdjCLQqWHSs5SwXi+K2sQu75ecsolSs=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-GH7ybr9ncbcvtyYCmYrG1aSA3lc+qmqivAbNVVqpMPQ=";

  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ beeb ];
  };
}
