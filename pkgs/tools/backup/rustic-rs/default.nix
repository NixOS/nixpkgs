{ lib, fetchFromGitHub, rustPlatform, stdenv, Security, installShellFiles, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
<<<<<<< HEAD
  version = "0.5.4";
=======
  version = "0.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-LAOU2cnKb+TEWNiXJkpgqNxuU16g/Kc3swGIUc8t9x0=";
  };

  cargoHash = "sha256-OTIdl2x5m90rEwNBu3LL3rFQ0FVS3GDYU7gf8P7CTaQ=";
=======
    hash = "sha256-OZ80foq6DQZoJuJsQT4hxAHvzYn+uJbqG29wiZ7mPi8=";
  };

  cargoHash = "sha256-xdSAdw6YY6mYZDBKkH20wfB1oNiKecC7XhRKLUaHsTQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
