{
  callPackage,
  lib,
  pnpm_11,
  pnpm_12,
}:
{
  pnpm-empty-lockfile = callPackage ./pnpm-empty-lockfile { };
  pnpm-fixup-state-db = callPackage ./pnpm-fixup-state-db { };
  pnpm-workspaces = lib.recurseIntoAttrs (callPackage ./pnpm-workspaces { });
  pnpm_11_v3 = callPackage ./pnpm_11_v3 { };
  pnpm_11_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_11;
    fetcherVersion = 4;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-/CwMd6V9Bp2kZASbbJQaNOG1ksbfuOQbwPs0p+zgn1E=";
  };
  pnpm_12_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 4;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-P7cooRuXXB3qmSrw6nrWooM7HBTTtKpA/1H19YwZ6Ys=";
  };
  pnpm_12_v5 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-5RGwG+P1C6XilXwvoeCYPBGAVCNp6puXMgV4CNNCzUw=";
  };
  pnpm_12_v5_gvs = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = true;
    pnpmDepsHash = "sha256-5RGwG+P1C6XilXwvoeCYPBGAVCNp6puXMgV4CNNCzUw=";
  };
}
