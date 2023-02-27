{ lib, fetchFromGitHub, rustPlatform, stdenv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "v${version}";
    hash = "sha256-xNevH/a1i5nrwv3bQVbr5JCuOKPu/hmQ8UZMZXBAiFw=";
  };

  cargoHash = "sha256-DaMtLtsGm3Vy3l7GtfcWclTiuSezQp6Lw8GbZt7Vdto=";

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
