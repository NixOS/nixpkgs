{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  stdenv,
  Security,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nQ9OIeFo79f2UBNE9dCl7+bt55XTjQTgWlfyP0Jkj1w=";
  };
  cargoHash = "sha256-8HgO8BqBWiygZmiuRL8WJy3OXSBAKFNVGN7NA6Fx2BM=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "A command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
    mainProgram = "coldsnap";
  };
}
