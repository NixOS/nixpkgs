{ stdenv, fetchurl, pkgconfig, vpnc, openssl, libxml2 } :

stdenv.mkDerivation rec {
  name = "openconnect-5.00";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
    ];
    sha256 = "8bacd8d00b2c0ecf35594a8417e695b5ed3a7757467f22f980134de81ee7713a";
  };

  preConfigure = ''
      export PKG_CONFIG=${pkgconfig}/bin/pkg-config
      export LIBXML2_CFLAGS="-I ${libxml2}/include/libxml2"
      export LIBXML2_LIBS="-L${libxml2}/lib -lxml2"
      export CFLAGS="-D NO_BROKEN_DTLS_CHECK $CFLAGS"
    '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"

  ];

  propagatedBuildInputs = [ vpnc openssl libxml2 ];
}
