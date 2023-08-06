{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, stdenv
, Security
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WqNGajtezhBDYmgUayKjdNAZSyKirIYeYOnozMCIya4=";
  };
  cargoHash = "sha256-av9hsvY8xsB+HlIRLYNFDJc9eyBfOyBZ347vWoVsDmM=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "A command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
