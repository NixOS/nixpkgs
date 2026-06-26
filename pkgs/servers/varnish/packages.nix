{
  callPackages,
  varnish80,
  lib,
}:
{
  varnish80Packages = lib.recurseIntoAttrs rec {
    varnish = varnish80;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules27;
  };
}
