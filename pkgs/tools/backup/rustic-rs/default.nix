{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
, SystemConfiguration
, installShellFiles
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "refs/tags/v${version}";
    hash = "sha256-rpIEgQYwfManfgTrhCt6/Q4VBY2yyn4edC6/mz5D7nM=";
  };

  cargoHash = "sha256-q+K887jPB9i9iXpFYXjn3zppAPWNlTc2AG7ivOr77J4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  postInstall = ''
    for shell in {ba,fi,z}sh; do
      $out/bin/rustic completions $shell > rustic.$shell
    done

    installShellCompletion rustic.{ba,fi,z}sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rustic-rs/rustic";
    changelog = "https://github.com/rustic-rs/rustic/blob/${src.rev}/CHANGELOG.md";
    description = "fast, encrypted, deduplicated backups powered by pure Rust";
    mainProgram = "rustic";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.mit lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.nobbz ];
  };
}
