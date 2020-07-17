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

  vendorSha256 = "1520h69z0inbsrw5505cxbinqakvwcrdx3pisrwnp9lv4jsrzzsr";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202007080004";
      geoipSha256 = "1j4qg831dhxdy7brgxn4ca69cvwr3zsgizidlzasbkdn2rwai17y";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20200708125309";
      geositeSha256 = "1pr4137ri3v3r880yx5sqf2p7qfn8g7s555q51x3smkjzkyrskcy";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

} // args)
