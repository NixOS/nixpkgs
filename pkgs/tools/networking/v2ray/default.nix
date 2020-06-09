{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.23.3";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "1b0cxrpgkmgas7pwxglsvgcig8rnhffkf990b42z7awji5lw055v";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202005270003";
      geoipSha256 = "10gf69hr32p4bpl5j8r46v8xzhpcgm70xbcdxm1a8l0jwyj0infs";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "202005292154";
      geositeSha256 = "0w6l0q8y14in5f4a406blpprqq6p438gpclnlfz7y2hkh5zf36cr";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
