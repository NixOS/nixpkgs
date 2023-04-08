{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kHw7hyOH/GAFRh0TErFMXU3NBge2AwpJr8oXbtnWCfc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-8biNETzXhR3GE5Ywrbcd4199h3ipwwZbtpZOQGOYA1g=";
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
