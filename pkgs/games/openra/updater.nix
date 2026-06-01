{
  lib,
  writeShellApplication,
  curl,
  jq,
  gnused,
  nix,
  nix-prefetch-github,
  common-updater-scripts,
}:
engine:

lib.getExe (writeShellApplication {
  name = "openra-updater";
  runtimeInputs = [
    curl
    jq
    gnused
    nix
    nix-prefetch-github
    common-updater-scripts
  ];
  runtimeEnv = {
    build = engine.build;
    currentVersion = engine.version;
    currentRev = lib.optionalString (lib.hasAttr "rev" engine) engine.rev;
  };
  bashOptions = [
    "errexit"
    "errtrace"
    "nounset"
    "pipefail"
  ];

  text = lib.readFile ./updater.sh;
})
