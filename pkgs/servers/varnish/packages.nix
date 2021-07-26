{ callPackage, varnish60, varnish65, fetchFromGitHub }: {
  varnish60Packages = {
    varnish = varnish60;
    digest  = callPackage ./digest.nix {
      varnish = varnish60;
      version = "libvmod-digest-1.0.2";
      sha256 = "0jwkqqalydn0pwfdhirl5zjhbc3hldvhh09hxrahibr72fgmgpbx";
    };
    dynamic = callPackage ./dynamic.nix  {
      varnish = varnish60;
      version = "0.4";
      sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
    };
  };
  varnish65Packages = {
    varnish = varnish65;
    digest  = callPackage ./digest.nix {
      varnish = varnish65;
      version = "6.6";
      sha256 = "0n33g8ml4bsyvcvl5lk7yng1ikvmcv8dd6bc1mv2lj4729pp97nn";
    };
    dynamic = callPackage ./dynamic.nix  {
      varnish = varnish65;
      version = "2.3.1";
      sha256 = "060vkba7jwcvx5704hh6ds0g0kfzpkdrg8548frvkrkz2s5j9y88";
    };
  };
}
