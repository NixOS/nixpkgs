{ lib, fetchFromGitHub, rustPlatform, stdenv, Security, installShellFiles, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "refs/tags/v${version}";
    hash = "sha256-LAOU2cnKb+TEWNiXJkpgqNxuU16g/Kc3swGIUc8t9x0=";
  };

  cargoHash = "sha256-OTIdl2x5m90rEwNBu3LL3rFQ0FVS3GDYU7gf8P7CTaQ=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    for shell in {ba,fi,z}sh; do
      $out/bin/rustic completions $shell > rustic.$shell
    done

    installShellCompletion rustic.{ba,fi,z}sh
  '';

  passthru.updateScript = nix-update-script { };

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
