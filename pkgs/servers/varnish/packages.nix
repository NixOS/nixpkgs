{ callPackage, varnish60, varnish62, varnish63 }:

{
  varnish60Packages = {
    varnish = varnish60;
    digest  = callPackage ./digest.nix   { varnish = varnish60; };
    dynamic = callPackage ./dynamic.nix  { varnish = varnish60; };
  };
  varnish62Packages = {
    varnish = varnish62;
  };
  varnish63Packages = {
    varnish = varnish63;
  };
}
