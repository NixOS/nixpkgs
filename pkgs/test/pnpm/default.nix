{
  callPackage,
  lib,
  opencloud,
  pnpm_11,
  pnpm_12,
}:

{
  pnpm-empty-lockfile = callPackage ./pnpm-empty-lockfile { };
  pnpm-fixup-state-db = callPackage ./pnpm-fixup-state-db { };
  pnpm-workspaces = lib.recurseIntoAttrs (callPackage ./pnpm-workspaces { });
  pnpm_11_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_11;
    fetcherVersion = 4;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-DaTcLGWd6QxndFVsRRceCPGn+UiwspYL60N5jwP6Iq4=";
  };
  pnpm_12_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 4;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-A1p8RubUB32OgMaJrSWew6/DpydRUOMCrpmMI7Morew=";
  };
  pnpm_12_v5 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-nnc+cFYZcP6aaxG5hjLEAJ7fv8tAYoVAlE/sAFc/bw4=";
  };
  pnpm_12_v5_gvs = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = true;
    pnpmDepsHash = "sha256-nnc+cFYZcP6aaxG5hjLEAJ7fv8tAYoVAlE/sAFc/bw4=";
  };

  # pnpm reverse dependencies that don't have a top-level package
  opencloud = lib.recurseIntoAttrs {
    inherit (opencloud.passthru) web idp-web;
  };
}
