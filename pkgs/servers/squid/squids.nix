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

    configureFlags = ["--enable-ipv6" "--disable-strict-error-checking"];

    meta = {
      description = "http-proxy";
      homepage = "http://www.squid-cache.org";
      license = "GPL2";
    };

  };

  squid31 = squid30.merge {
    name = "squid-3.1.23";
    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.23.tar.bz2;
      sha256 = "13g4y0gg48xnlzrvpymb08gh25xi50y383faapkxws7i7v94305s";
    };
  };

  squid32 = squid30.merge rec {
    name = "squid-3.2.13";
    src = args.fetchurl {
      url = "http://www.squid-cache.org/Versions/v3/3.2/${name}.tar.bz2";
      sha256 = "0dafqv00dr3nyrm9k47d6r7gv2r3f9hjd1ykl3kkvjca11r4n54j";
    };
    buildInputs = [openldap pam db cyrus_sasl libcap expat libxml2
      libtool openssl];
  };

  latest = squid32;
}
