{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, Foundation, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dzsqppkcxvajyybmday8xnwwwqv3g44hb5fzqy4whkblwxbn2gk";
  };

  cargoSha256 = "1bcj1rd78kgiy1xqpkxffzl6v9xdp778y66g6nhikjq2yarz77ji";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Foundation
    Security
    libiconv
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
