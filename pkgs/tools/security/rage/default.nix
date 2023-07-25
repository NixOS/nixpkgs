{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hFuuwmwe0ti4Y8mSJyNqUIhZjFC6qtv6W5cwtNjPUFQ=";
  };

  cargoHash = "sha256-1gtLWU6uiWzUfYy9y3pb2vcnUC3H+Mf9rglmqNd989M=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Foundation
  ];

  # cargo test has an x86-only dependency
  doCheck = stdenv.hostPlatform.isx86;

  postBuild = ''
    cargo run --example generate-docs
    cargo run --example generate-completions
  '';

  postInstall = ''
    installManPage target/manpages/*
    installShellCompletion target/completions/*.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "A simple, secure and modern encryption tool with small explicit keys, no config options, and UNIX-style composability";
    homepage = "https://github.com/str4d/rage";
    changelog = "https://github.com/str4d/rage/raw/v${version}/rage/CHANGELOG.md";
    license = with licenses; [ asl20 mit ]; # either at your option
    maintainers = with maintainers; [ marsam ryantm ];
  };
}
