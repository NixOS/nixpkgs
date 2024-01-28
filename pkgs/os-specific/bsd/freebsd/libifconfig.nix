{ mkDerivation, lib, stdenv, buildPackages, patchesRoot, ...}:
mkDerivation {
  path = "lib/libifconfig";
  extraPaths = [ "tools/lua" "lib/libc/Versions.def" ];
  patches = [ /${patchesRoot}/libifconfig-no-internal.patch ];

  LUA = "${buildPackages.lua}/bin/lua";

  clangFixup = true;
}
