{ callPackage }:
{
  pnpm-empty-lockfile = callPackage ./pnpm-empty-lockfile { };
  pnpm-fixup-state-db = callPackage ./pnpm-fixup-state-db { };
}
