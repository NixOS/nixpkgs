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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zXLt16ffqbExU23uRI7U99nUwpSKTIf039dDq+k2KAA=";
  };
  cargoHash = "sha256-RRyAzD9eiscZ9kB5tFh5vUnGk6XYYKy0/TAjcaygmG4=";

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
