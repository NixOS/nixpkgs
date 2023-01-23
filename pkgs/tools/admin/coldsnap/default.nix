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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+JQjJ4F++S3eLnrqV1v4leepOvZBf8Vp575rnlDx2Cg=";
  };
  cargoHash = "sha256-mAnoe9rK4+OpCzD7tzV+FQz+fFr8NapzsXtON3lS/tk";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "A command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.apsl20;
    maintainers = teams.determinatesystems.members;
  };
}
