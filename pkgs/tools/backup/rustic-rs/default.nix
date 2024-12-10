{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  Security,
  SystemConfiguration,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustic-rs";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rustic-rs";
    repo = "rustic";
    rev = "refs/tags/v${version}";
    hash = "sha256-jUAmboJTzX4oJZy9rFiPRbm94bVpZGa0SaqotoCU/Ss=";
  };

  cargoHash = "sha256-iZuWlYDGGziwb49BfKdt9Ahs6oQ0Ij2iiT0tvL7ZIVk=";

  # At the time of writing, upstream defaults to "self-update" and "webdav".
  # "self-update" is a self-updater, which we don't want in nixpkgs.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "webdav"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

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
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.nobbz ];
  };
}
