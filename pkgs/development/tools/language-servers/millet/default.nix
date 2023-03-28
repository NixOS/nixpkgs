{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b5zb0sDya/58kEEgqWqu4u6Xo61sq8Le0F3Z1Q3dBdk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-mQU6kmVizJJTb3JF61YWUVZqSeGSs6PluCF32y/uov8=";
      "rowan-0.15.10" = "sha256-yOaUq2tQEiNgQB7qB8fFzfnwUWagu72MIPHmaTX0B0Y=";
      "sml-libs-0.1.0" = "sha256-6jbRMqlW5sL0x0i4qatduXvLHhrkUE7gsSwC6JYwiHQ=";
    };
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [ "--package" "millet-ls" ];

  cargoTestFlags = [ "--package" "millet-ls" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/CHANGELOG.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "millet-ls";
  };
}
