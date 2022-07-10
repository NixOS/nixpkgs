{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FexplUdn56TanxAKC+a8uWoR3soJT1/1qi9t2tw19Vw=";
  };

  cargoSha256 = "sha256-xlpi6UQTL1p9JSLENKrLjG2DF9mYiV+E8bfjHQtqOyY=";

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
