{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-HFqkWJu1whShwEsSUZe5orWTNYyY3oZ6tBzAJF3SFDw=";
  };

  cargoHash = "sha256-oEzsJoVD9aSvphchm21dlmkwePMDSaxD7eoR850NbRk=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-08-24"; # managed via the update script
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
