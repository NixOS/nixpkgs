{ callPackage, varnish60, varnish65 }:

{
  varnish60Packages = {
    varnish = varnish60;
    digest  = callPackage ./digest.nix   { varnish = varnish60; };
    dynamic = callPackage ./dynamic.nix  { varnish = varnish60; };
  };
  varnish65Packages = {
    varnish = varnish65;
  };
}
