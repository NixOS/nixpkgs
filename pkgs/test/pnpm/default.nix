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
    pnpmDepsHash = "sha256-1u7zEw4tU9n3hYsVjiQPioGUHy9dN5yeQyidVyBvnQI=";
  };
  pnpm_12_v4 = callPackage ./integration/default.nix {
    pnpm = pnpm_12;
    pnpmDepsHash = "sha256-cj/RldHr60y9KwktAexAJI0hmp4HcIaBgbO1N2hkGVI=";
  };
}
