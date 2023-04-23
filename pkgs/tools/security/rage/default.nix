{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-df+ch0JfPgmf/qKMV3sBSmfCvRTazVnAa1SRRvhrteQ=";
  };

  cargoHash = "sha256-GW3u3LyUJqu4AMnb/2M7mYa45qbRtG2IDuCJoEVOfn0=";

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
