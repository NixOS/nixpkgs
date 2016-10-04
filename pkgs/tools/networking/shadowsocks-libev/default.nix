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

  version = "2.5.0";
  sha256 = "6841e0efa1c01caef5a827f463ee304dc9e48fb4751cc9256316df5ab4490ae0";

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
