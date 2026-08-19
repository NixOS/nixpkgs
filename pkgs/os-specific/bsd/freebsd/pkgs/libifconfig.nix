{ mkDerivation, buildPackages }:
mkDerivation {
  path = "lib/libifconfig";
  extraPaths = [
    "tools/lua"
    "lib/libc/Versions.def"
  ];
  LUA = "${buildPackages.lua}/bin/lua";
}
