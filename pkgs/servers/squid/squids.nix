args: with args;
let edf = composableDerivation.edf; in
rec {
  squid30 = composableDerivation.composableDerivation {} {
    name = "squid-3.0-stable26";

    buildInputs = [perl];

    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.0/squid-3.0.STABLE26.tar.bz2;
      sha256 = "3e54ae3ad09870203862f0856c7d0cca16a85f62d5012085009003ee3d5467b4";
    };

    configureFlags = ["--enable-ipv6"];

    meta = {
      description = "http-proxy";
      homepage = "http://www.squid-cache.org";
      license = "GPL2";
    };

  };

  squid31 = squid30.merge {
    name = "squid-3.1.15";
    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.15.tar.bz2;
      sha256 = "1300f44dd4783697bacc262a7a9b32dbc9f550367fe82b70262864fdff715a35";
    };
    configureFlags = ["--enable-ipv6"];
  };

  squid32 = squid30.merge rec {
    name = "squid-3.2.2";
    src = args.fetchurl {
      url = "http://www.squid-cache.org/Versions/v3/3.2/${name}.tar.bz2";
      sha256 = "13jlx3d6rqq7ajxs8bgn8a0mh932jhq6aa8032q205nxnhqs0l4l";
    };
    configureFlags = ["--enable-ipv6"];
    buildInputs = [openldap pam db4 cyrus_sasl libcap expat libxml2
      libtool openssl];
  };

  latest = squid32;
}
