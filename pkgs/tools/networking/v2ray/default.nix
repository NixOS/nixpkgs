{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.26.0";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "069wm0n44i4l9pnrhwf60ssld65p6gfj4wfc68hrhj4zi4jvlyds";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202007150004";
      geoipSha256 = "0plim7k9ddv1m0xrhnnffdnml5z2y7j3lvbiggxapdjp4brf1w6l";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20200716163333";
      geositeSha256 = "0rp2hxm7k6w5pl06fl2nwfc5wrbn9axyinjvvdamp2zqzh7lw1q3";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
