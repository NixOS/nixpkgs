{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.27.5";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "168kz8hq7mcfy6h758mmrky550p04bi9jsfqhy67jcxq81874m2k";
  };

  vendorSha256 = "0m889byxw70vv1mzlivalq444byp0y182nqqzdr458gfifvpc7s7";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202009020005";
      geoipSha256 = "1xsy678cpqv6ycnhzl3pms76ic40aggq46q9dsd5ghj94mcx9837";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20200901194123";
      geositeSha256 = "0fjx1wrq14d9v326k4fjwca3h5nv8ghk11kprf6jkjncjszwvgby";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
