{
  callPackages,
  callPackage,
  varnish60,
  varnish74,
  varnish75,
}:
{
  varnish60Packages = rec {
    varnish = varnish60;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules15;
    digest = callPackage ./digest.nix {
      inherit varnish;
      version = "libvmod-digest-1.0.2";
      sha256 = "0jwkqqalydn0pwfdhirl5zjhbc3hldvhh09hxrahibr72fgmgpbx";
    };
    dynamic = callPackage ./dynamic.nix {
      inherit varnish;
      version = "0.4";
      sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
    };
  };
  varnish74Packages = rec {
    varnish = varnish74;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules23;
  };
  varnish75Packages = rec {
    varnish = varnish75;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules24;
  };
}
