{ lib, stdenv, rustPlatform, python3, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "rust-synapse-compress-state";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SSfVtG8kwHarVbB1O7xC2SSbUpPGYMHTMyoxu8mpEk0=";
  };

  cargoSha256 = "sha256-PG+UeovhJMsIlm5dOYdtMxbUxZjwG3V59kAcB9aFP5c=";

  cargoBuildFlags = [
    "--all"
  ];

  nativeBuildInputs = [ python3 pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
