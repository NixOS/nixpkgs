{ stdenv, fetchurl, pkgconfig, vpnc, openssl, libxml2 } :

stdenv.mkDerivation rec {
  name = "openconnect-5.02";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
    ];
    sha256 = "1y7dn42gd3763sgwv2j72xy9hsikd6y9x142g84kwdbn0y0psgi4";
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
