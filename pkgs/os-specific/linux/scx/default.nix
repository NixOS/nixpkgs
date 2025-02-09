{
  lib,
  callPackage,
  fetchFromGitHub,
}:
let
  scx-common = rec {
    versionInfo = lib.importJSON ./version.json;

    inherit (versionInfo.scx) version;

    src = fetchFromGitHub {
      owner = "sched-ext";
      repo = "scx";
      rev = "refs/tags/v${versionInfo.scx.version}";
      inherit (versionInfo.scx) hash;
    };

    meta = {
      homepage = "https://github.com/sched-ext/scx";
      changelog = "https://github.com/sched-ext/scx/releases/tag/v${versionInfo.scx.version}";
      license = lib.licenses.gpl2Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ johnrtitor ];
    };
  };

  schedulers = lib.mergeAttrsList [
    { cscheds = import ./scx_cscheds.nix; }
    { rustscheds = import ./scx_rustscheds.nix; }
    { full = import ./scx_full.nix; }
  ];
in
(lib.mapAttrs (name: scheduler: callPackage scheduler { inherit scx-common; }) schedulers)
// {
  inherit scx-common;
}
