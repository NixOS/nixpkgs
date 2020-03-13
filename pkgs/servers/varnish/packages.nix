{ callPackage, varnish60, varnish62, varnish63 }:

{
  varnish60Packages = {
    varnish = varnish60;
    digest  = callPackage ./digest.nix   { varnish = varnish60; };
    dynamic = callPackage ./dynamic.nix  { varnish = varnish60; };
    modules = callPackage ./modules.nix  { varnish = varnish60; };
    geoip2  = callPackage ./geoip2.nix   { varnish = varnish60; };
  };
  varnish62Packages = {
    varnish = varnish62;
    digest  = callPackage ./digest.nix   { varnish = varnish62; };
    dynamic = callPackage ./dynamic.nix  { varnish = varnish62; };
    modules = callPackage ./modules.nix  { varnish = varnish62; };
    geoip2  = callPackage ./geoip2.nix   { varnish = varnish62; };
  };
  varnish63Packages = {
    varnish = varnish63;
    digest  = callPackage ./digest.nix   { varnish = varnish63; };
    dynamic = callPackage ./dynamic.nix  { varnish = varnish63; };
    modules = callPackage ./modules.nix  { varnish = varnish63; };
    geoip2  = callPackage ./geoip2.nix   { varnish = varnish63; };
  };
}
