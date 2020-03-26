{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.23.0";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0if53d1blj1wf572z21dsywx6czbmhs5dpccx5z1knjhh2xgg9lm";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202003180002";
      geoipSha256 = "08d383phc5qk7glq25nkf1g8za38415x2952phy525ail88afpwl";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "202003221514";
      geositeSha256 = "1d4gv6714m97i57srrzybnmc4322qv5lypkqbmhcxb8bi4ljpf1m";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
