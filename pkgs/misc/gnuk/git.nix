{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-22";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "3d5a776ab15a4ae6e17d91341a58eda3db09f700";
    sha256 = "1f9l1rwy630z8cnjd6lfv0zp6ij3c9ifbm3fym245049hh2xds7v";
  };
})
