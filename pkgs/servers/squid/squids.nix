args: with args;
let edf = composableDerivation.edf; in
rec {
  squid30 = composableDerivation.composableDerivation {} {
    name = "squid-3.0-stable5";

    buildInputs = [perl];

    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.0/squid-3.0.STABLE5.tar.bz2;
      sha256 = "1m4ccpjw30q9vwsycmgg9dmhly0mpznvxrch6f7dxgfzpjp26l7w";
    };

    configureFlags = ["--enable-ipv6"];

    meta = {
      description = "http-proxy";
      homepage = "http://www.squid-cache.org";
      license = "GPL2";
    };

  };

  squid3Beta = squid30.merge {
    name = "squid-3.1-beta";
    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.0.16.tar.bz2;
      sha256 = "0pjz8dj04146hgdlfh0hbwdsdahsicdkafj5z9nkghbjavj1x5ny";
    };
    configureFlags = ["--enable-ipv6"];
  };

  squid3Head = squid3Beta.merge {
    name = "squid-3.1-HEAD";
    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.0.3-20081221.tar.bz2;
      md5 = "345b50251dcc369e1be992d0a4a4c801";
    };
  };

  latest = squid3Beta;
}
