{ callPackage, varnish4, varnish5, varnish6 }:

{
  varnish4Packages = {
    varnish = varnish4;
    digest   = callPackage ./digest.nix   { varnish = varnish4; };
    rtstatus = callPackage ./rtstatus.nix { varnish = varnish4; }; # varnish4 only
    modules  = callPackage ./modules.nix  { varnish = varnish4; }; # varnish4 and varnish5 only
    geoip    = callPackage ./geoip.nix    { varnish = varnish4; }; # varnish4 and varnish5 only
  };
  varnish5Packages = {
    varnish = varnish5;
    digest   = callPackage ./digest.nix   { varnish = varnish5; };
    dynamic  = callPackage ./dynamic.nix  { varnish = varnish5; }; # varnish5 only (upstream has a separate branch for varnish4)
    modules  = callPackage ./modules.nix  { varnish = varnish5; }; # varnish4 and varnish5 only
    geoip    = callPackage ./geoip.nix    { varnish = varnish5; }; # varnish4 and varnish5 only
  };
  varnish6Packages = {
    varnish = varnish6;
    digest   = callPackage ./digest.nix   { varnish = varnish6; };
  };
}
