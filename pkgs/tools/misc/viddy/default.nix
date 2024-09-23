{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-vlPG7nYWCNfhZJOm6qmYNK5OwkckVZFRQWMhDX2vWTc=";
  };

  cargoHash = "sha256-YM73+f/a1iE+lRots/CNfYcU8iZ7xiAKjDHOIywOo6o=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-09-05"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = with lib; {
    description = "Modern watch command, time machine and pager etc.";
    changelog = "https://github.com/sachaos/viddy/releases";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [
      j-hui
      phanirithvij
    ];
    mainProgram = "viddy";
  };
}
