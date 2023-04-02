{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TWxhppR3G1u3YkyeIHKBWprqOn22YhRIORkAVaFR/RY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-4DX/o1CjZ08mDXXPy87GNXiikP9L9nyhR7qYzCPVtAY=";
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
