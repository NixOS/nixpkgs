# Check that evaluating all the packages, with the abi patching mechanism
# with no fixes is effectively a no-op.

with import ./lib.nix;

assert builtins.trace "Found ${builtins.toString (builtins.length pkgsDrvs)} packages." true;
assert builtins.length pkgsDrvs == builtins.length abifixDrvs;
assert lib.all lib.id (zipPkgs pkgsDrvs abifixDrvs);
true
