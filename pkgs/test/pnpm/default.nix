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
    pnpmDepsHash = "sha256-jT7VRHQh3txgiX0Kbya4oMzZck2rxjrFGSddUWZyfNM=";
  };
  pnpm_12_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 4;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-4oBTHX0kewsdEK5+xodf+pcO8JOEVXq+VvvpbbyTJYM=";
  };
  pnpm_12_v5 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = false;
    pnpmDepsHash = "sha256-Ou2RWj/ddu6qGqRDGF8cx94N6IiH8NxNmxcI0cBGzdM=";
  };
  pnpm_12_v5_gvs = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    fetcherVersion = 5;
    enableGlobalVirtualStore = true;
    pnpmDepsHash = "sha256-Ou2RWj/ddu6qGqRDGF8cx94N6IiH8NxNmxcI0cBGzdM=";
  };
}
