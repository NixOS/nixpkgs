{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.22.0";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "1gr4s96ii4dx5bcwpb82rn250pcnncxwzx147p9dbwbyiy0i9nz7";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202001010102";
      geoipSha256 = "16i73c3852f7zmya0q3856cc4gvhqhpln9s98qvr2dr1mpp72c1w";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20191226.1";
      geositeSha256 = "0b4ji5kj5jpkwri3libxm9yl49dcy91vkl7h1rkhrrhbl17s3qiy";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
