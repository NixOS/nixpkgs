{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "claudia-statusline";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "cosmikwolf";
    repo = "statusline";
    rev = "v${version}";
    hash = "sha256-LvjW5wv4lZd8k4V8Xp99JCu0T1D/WhKVjRxdZfZLkL4=";
  };

  cargoHash = "sha256-NAaTUfqhbXFBAh2GQHAFPXjGTC8MnNnTgN1uDA0lhJs=";

  patches = [ ./remove-strip-feature.patch ];

  # Skip tests that require network or are incompatible with Nix sandbox
  checkFlags = [
    "--skip=git_utils::tests::test_timeout_kills_process"
    "--skip=git_utils::tests::test_git_with_locks_env"
    "--skip=display::tests::test_theme_affects_colors"
  ];

  cargoTestFlags = [ "--lib" ];

  meta = with lib; {
    description = "Intelligent statusline generator with Git integration for Claude Code";
    homepage = "https://github.com/cosmikwolf/statusline";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "statusline";
  };
}
