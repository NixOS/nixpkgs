args @ { fetchurl, stdenv, perl, lib, composableDerivation
, openldap, pam, db, cyrus_sasl, kerberos, libcap, expat, libxml2, libtool
, openssl, ... }: with args;
let edf = composableDerivation.edf; in
rec {
  squid30 = composableDerivation.composableDerivation {} {
    name = "squid-3.0-stable26";

    buildInputs = [perl];

    src = args.fetchurl {
      url = http://www.squid-cache.org/Versions/v3/3.0/squid-3.0.STABLE26.tar.bz2;
      sha256 = "3e54ae3ad09870203862f0856c7d0cca16a85f62d5012085009003ee3d5467b4";
    };

    configureFlags = ["--enable-ipv6" "--disable-strict-error-checking" "--disable-arch-native"];

    meta = {
      description = "http-proxy";
      homepage = "http://www.squid-cache.org";
      license = stdenv.lib.licenses.gpl2;
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
    name = "squid-3.2.14";
    src = args.fetchurl {
      url = "http://www.squid-cache.org/Versions/v3/3.2/${name}.tar.bz2";
      sha256 = "12azbnsq4gkhdaqm0swd2046hbi44max3l7kl2p1dv3mvy5csn60";
    };
    buildInputs = [openldap pam db cyrus_sasl libcap expat libxml2
      libtool openssl];
  };

  squid34 = squid30.merge rec {
    name = "squid-3.4.14";
    src = args.fetchurl {
      url = "http://www.squid-cache.org/Versions/v3/3.4/${name}.tar.bz2";
      sha256 = "13y446s3nzaxzimqsqranhw9k891kr4v2hhddkxla61ag7pkjr9n";
    };
    buildInputs = [openldap pam db cyrus_sasl libcap expat libxml2
      libtool openssl];
    configureFlags = ["--enable-ssl" "--enable-ssl-crtd"];
  };

  squid35 = squid30.merge rec {
    name = "squid-3.5.17";
    src = args.fetchurl {
      url = "http://www.squid-cache.org/Versions/v3/3.5/${name}.tar.bz2";
      sha256 = "1kdq778cm18ak4624gchmbi8avnzyvwgyzjplkd0fkcrgfs44bsf";
    };
    buildInputs = [openldap pam db cyrus_sasl libcap expat libxml2
      libtool openssl];
    configureFlags = ["--with-openssl" "--enable-ssl-crtd"];
  };

  latest = squid35;
}
