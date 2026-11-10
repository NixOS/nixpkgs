{ mkDerivation, buildPackages }:
mkDerivation {
  path = "lib/libifconfig";
  extraPaths = [
    "tools/lua"
    "lib/libc/Versions.def"
  ];
  LUA = "${buildPackages.lua5_2_compat}/bin/lua";
}
