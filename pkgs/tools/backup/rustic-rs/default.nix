{ lib, fetchFromGitHub, rustPlatform, stdenv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "v${version}";
    hash = "sha256-IyGSyyWhwxrevxWbnlfLVK0+Y1ZoKx2Dg1SRydG3nuo=";
  };

  cargoHash = "sha256-AE6z8/RO18FppLwsuz38JF/asI9dOLYmAErj1jzM3JA=";

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
