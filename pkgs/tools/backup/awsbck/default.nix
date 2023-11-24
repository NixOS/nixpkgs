{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-BitR4f1VzYs5L7hT5OCbBbe4JvPIOPDQ9byKEkfBDBY=";
  };

  cargoHash = "sha256-J5BI6Gv20iAe2XCt1riLATCnlOg+pcj7q2Gzo2ZN0ms=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ beeb ];
    mainProgram = "awsbck";
  };
}
