{
  callPackage,
  lib,
  opencloud,
}:

{
  pnpm-empty-lockfile = callPackage ./pnpm-empty-lockfile { };
  pnpm-fixup-state-db = callPackage ./pnpm-fixup-state-db { };
  pnpm-workspaces = lib.recurseIntoAttrs (callPackage ./pnpm-workspaces { });
  pnpm_11_v3 = callPackage ./pnpm_11_v3 { };
  pnpm_11_v4 = callPackage ./pnpm_11_v4 { };

  # pnpm reverse dependencies that don't have a top-level package
  opencloud = lib.recurseIntoAttrs {
    inherit (opencloud.passthru) web idp-web;
  };
}
