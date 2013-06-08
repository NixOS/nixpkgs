{ stdenv, fetchurl, pkgconfig, vpnc, openssl, libxml2 } :

stdenv.mkDerivation rec {
  name = "openconnect-5.01";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
    ];
    sha256 = "1l90ks87iwmy7jprav11lhjr4n18ycy0d9fndspg50p9qd3jlvwi";
  };

  preConfigure = ''
      export PKG_CONFIG=${pkgconfig}/bin/pkg-config
      export LIBXML2_CFLAGS="-I ${libxml2}/include/libxml2"
      export LIBXML2_LIBS="-L${libxml2}/lib -lxml2"
    '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  propagatedBuildInputs = [ vpnc openssl libxml2 ];
}
