{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, Foundation, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vag448zpjyplcjpf1ir81l8ip3yxm9vkrxffqr78zslb4k6hw2w";
  };

  cargoSha256 = "06jfhq9vnkq5g5bw1zl2sxsih63yajcyk9zaizhzkdsbhydr4955";

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
