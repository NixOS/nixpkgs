{ callPackage }:
{
  pnpm-empty-lockfile = callPackage ./pnpm-empty-lockfile { };
  pnpm-fixup-state-db = callPackage ./pnpm-fixup-state-db { };
  pnpm_11_v3 = callPackage ./pnpm_11_v3 { };
  pnpm_11_v4 = callPackage ./pnpm_11_v4 { };
}
