{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-asYXmBPNsIac+c/UXSijol+DFI7qZVpg/SKxaadlBOI=";
  };

  cargoHash = "sha256-vFIBl/ZvSZn/9yLYMtzFvlPM+OYkZndkT6qPCIWVlOM=";

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
