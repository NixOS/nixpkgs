{ withMbedTLS ? true
, enableSystemSharedLib ? true
, stdenv, fetchurl, zlib
, openssl ? null
, mbedtls ? null
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
                ++ optional (!withMbedTLS) openssl
                ++ optional withMbedTLS mbedtls
                ++ optional enableSystemSharedLib [libev libsodium udns];

  configureFlags = optional withMbedTLS
                     [ "--with-crypto-library=mbedtls"
                       "--with-mbedtls=${mbedtls}"
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
