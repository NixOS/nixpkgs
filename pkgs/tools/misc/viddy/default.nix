{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-dsvPNMNT1CXB6Wgq438wRHt9og+4uFWgiWPore4mRE0=";
  };

  cargoHash = "sha256-18OEOV8kET+UcLd15YultkonbXBEY/AwBHFNw4YTAPk=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-09-01"; # managed via the update script
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
