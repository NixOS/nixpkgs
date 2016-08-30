{ withMbedTLS ? true
, enableSystemSharedLib ? true
, stdenv, fetchurl, zlib
, openssl ? null
, mbedtls ? null
, libev ? null
, libsodium ? null
, udns ? null
, asciidoc
, xmlto
, docbook_xml_dtd_45
, docbook_xsl
, libxslt
}:

let

  version = "2.4.8";
  sha256 = "af3fc3be50fb24dfd1aed8ce34d2d13448735f6181269f54f4860438a1838472";

in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "shadowsocks-libev-${version}";
  src = fetchurl {
    url = "https://github.com/shadowsocks/shadowsocks-libev/archive/v${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ zlib asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt ]
                ++ optional (!withMbedTLS) openssl
                ++ optional withMbedTLS mbedtls
                ++ optionals enableSystemSharedLib [libev libsodium udns];

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
