{ callPackage, fetchFromGitHub, fetchurl
, assetOverrides ? {}
, ... } @ args:

callPackage ./generic.nix (rec {
  version = "4.21.3";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0z45nrjnalrvpprq7g4zrjbrdkc3d3lhs4ci8hb8m69f92asiwbs";
  };

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "20190516.1";
      geoipSha256 = "14h4rq7rlcl1397pwpylfgwpk3fiscpzqb04c4wd5lxkfvk5f02r";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20191121.1";
      geositeSha256 = "0ijmvy43pvm69w38djf114j8swni7wfq5ry9wdpv9dj0rzb59m74";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
