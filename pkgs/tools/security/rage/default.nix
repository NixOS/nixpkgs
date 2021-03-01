{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, Foundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XSDfAsXfwSoe5JMdJtZlC324Sra+4fVJhE3/k2TthEc=";
  };

  cargoSha256 = "sha256-GPr5zxeODAjD+ynp/nned9gZUiReYcdzosuEbLIKZSs=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Foundation
    Security
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
    changelog = "https://github.com/str4d/rage/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ]; # either at your option
    maintainers = with maintainers; [ marsam ryantm ];
  };
}
