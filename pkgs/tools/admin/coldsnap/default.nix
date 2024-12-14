{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NYMcCLFhX7eD6GXMP9NZDXDnXDDVbcvVwhUAqmwX+ig=";
  };
  cargoHash = "sha256-ngkoxybl52zTH4wo+sIUtU8vtzOAp+jU1RyTO2KbCgU=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "Command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
    mainProgram = "coldsnap";
  };
}
