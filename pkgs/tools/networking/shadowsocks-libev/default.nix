{ withPolarSSL ? false
, stdenv, fetchurl, zlib
, openssl ? null
, polarssl ? null
}:

let

  version = "2.4.6";
  sha256 = "c87781bc280d7a7180cf82b17ad4e8f38242c73431d5b4b6cd4ccd0c29e1fe93";

in

stdenv.mkDerivation rec {
  inherit version;
  name = "shadowsocks-libev-${version}";
  src = fetchurl {
    url = "https://github.com/shadowsocks/shadowsocks-libev/archive/v${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ zlib ]
                ++ stdenv.lib.optional (!withPolarSSL) openssl
                ++ stdenv.lib.optional withPolarSSL polarssl;

  configureFlags = stdenv.lib.optional (withPolarSSL)
                     [ "--with-crypto-library=polarssl"
                       "--with-polarssl=${polarssl}"
                     ];

  meta = {
    description = "A lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.
      It is a port of Shadowsocks created by @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = https://github.com/shadowsocks/shadowsocks-libev;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.nfjinjing ];
    platforms = stdenv.lib.platforms.all;
  };
}
