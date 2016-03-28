with import ./lib.nix;

assert builtins.trace "Found ${builtins.toString (builtins.length pkgsDrvs)} packages." true;
assert builtins.length pkgsDrvs == builtins.length onefixDrvs;
assert lib.all lib.id (zipPkgs pkgsDrvs onefixDrvs);
true
