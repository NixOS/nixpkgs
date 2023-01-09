{ lib, fetchFromGitHub, rustPlatform, stdenv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "v${version}";
    hash = "sha256-2WU7tgt7F1sjUmT8gKE2di0hMD8nOvDwoQN87FCVZEc=";
  };

  cargoHash = "sha256-z1Zdzh6NsSIxOvDTzMbMPRCBl/MCxN2aaEejdxPtbSI=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    for shell in {ba,fi,z}sh; do
      $out/bin/rustic completions $shell > rustic.$shell
    done

    installShellCompletion rustic.{ba,fi,z}sh
  '';

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${src.rev}/changelog/${version}.txt";
    description = "fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.mit lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.nobbz ];
  };
}
