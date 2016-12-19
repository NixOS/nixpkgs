{ stdenv, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null, libxml2, zlib } :

let
  xor = a: b: (a || b) && (!(a && b));
in

assert xor (openssl != null) (gnutls != null);

stdenv.mkDerivation rec {
  name = "openconnect-7.06";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
    ];
    sha256 = "1wkhmgfxkdkhy2p9w9idrgipxmxij2z4f88flfk3fifwd19nkkzs";
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
  propagatedBuildInputs = [ vpnc openssl gnutls libxml2 zlib ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
