{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-L5hQ6vwuC9HuAGD9mvS8BGkPV3Ry5jJgRUF4Qf7fqaM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-VKm27IzCUv3e1Mapb46SBJqvEwifgGxaRX2uM9MTNnQ=";

  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ beeb ];
  };
}
