{ withPolarSSL ? false
, enableSystemSharedLib ? true
, stdenv, fetchurl, zlib
, openssl ? null
, polarssl ? null
, libev ? null
, libsodium ? null
, udns ? null
}:

let

  version = "2.4.7";
  sha256 = "957265cc5339e020d8c8bb7414ab14936e3939dc7355f334aec896ec9b03c6ed";

in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "shadowsocks-libev-${version}";
  src = fetchurl {
    url = "https://github.com/shadowsocks/shadowsocks-libev/archive/v${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ zlib ]
                ++ optional (!withPolarSSL) openssl
                ++ optional withPolarSSL polarssl
                ++ optional enableSystemSharedLib [libev libsodium udns];

  configureFlags = optional withPolarSSL
                     [ "--with-crypto-library=polarssl"
                       "--with-polarssl=${polarssl}"
                     ]
                   ++ optional enableSystemSharedLib "--enable-system-shared-lib";

  meta = {
    description = "A lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.
      It is a port of Shadowsocks created by @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = https://github.com/shadowsocks/shadowsocks-libev;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.nfjinjing ];
    platforms = platforms.all;
  };
}
