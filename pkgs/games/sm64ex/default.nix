{
  callPackage,
  branch,
  _60fps ? true,
}:

{
  sm64ex = callPackage ./sm64ex.nix { inherit _60fps; };
}
.${branch}
