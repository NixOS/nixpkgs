{ stdenv, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib } :

let
  xor = a: b: (a || b) && (!(a && b));
in

assert xor (openssl != null) (gnutls != null);

stdenv.mkDerivation rec {
  name = "openconnect-7.08";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
    ];
    sha256 = "00wacb79l2c45f94gxs63b9z25wlciarasvjrb8jb8566wgyqi0w";
  };

  preConfigure = ''
      export PKG_CONFIG=${pkgconfig}/bin/pkg-config
      export LIBXML2_CFLAGS="-I ${libxml2.dev}/include/libxml2"
      export LIBXML2_LIBS="-L${libxml2.out}/lib -lxml2"
    '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib ];

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ pradeepchhetri ];
    platforms = stdenv.lib.platforms.linux;
  };
}
