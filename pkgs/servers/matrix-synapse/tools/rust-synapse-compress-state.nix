{ lib, rustPlatform, python3, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "rust-synapse-compress-state";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uL7uoJPvZoTbrmEFY7jiBphvjWSRpH9pyk3x7s3Yvrs=";
  };

  cargoSha256 = "sha256-3w5RyVrpCnetXnxnzgVl94kUZa+1i9bU2O8vp7sb3lY=";

  cargoBuildFlags = [
    "--all"
  ];

  nativeBuildInputs = [ python3 pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
