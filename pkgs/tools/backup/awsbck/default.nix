{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-MDlFCbBAvGovhCO5uxXRQhIN4Fw9wav0afIBNzz3Mow=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-p7t/QtihdP6dyJ7tKpNkqcyYJvFJG8+fPqSGH7DNAtg=";

  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ beeb ];
  };
}
