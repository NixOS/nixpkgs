<<<<<<< HEAD
{ callPackages, callPackage, varnish60, varnish72, varnish73, fetchFromGitHub }: {
=======
{ callPackages, callPackage, varnish60, varnish72, fetchFromGitHub }: {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  varnish60Packages = rec {
    varnish = varnish60;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules15;
    digest  = callPackage ./digest.nix {
      inherit varnish;
      version = "libvmod-digest-1.0.2";
      sha256 = "0jwkqqalydn0pwfdhirl5zjhbc3hldvhh09hxrahibr72fgmgpbx";
    };
    dynamic = callPackage ./dynamic.nix  {
      inherit varnish;
      version = "0.4";
      sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
    };
  };
  varnish72Packages = rec {
    varnish = varnish72;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules20;
  };
<<<<<<< HEAD
  varnish73Packages = rec {
    varnish = varnish73;
    modules = (callPackages ./modules.nix { inherit varnish; }).modules22;
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
