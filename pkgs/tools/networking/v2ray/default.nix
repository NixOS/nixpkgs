{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.22.1";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0l4rg9galjcm6dzv7sapnim9a02z7pv354mk5mwqndznii6nkr73";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202001210102";
      geoipSha256 = "1wxhrhrigjqzpy5w8yj7yd9ib245xwhqys2pf9prdknq71piyziz";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "202001211332";
      geositeSha256 = "06qlbjxk21lhyh5l3pd8l4m9rdl7sjh2jriz51zihaqx4417f0m7";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
