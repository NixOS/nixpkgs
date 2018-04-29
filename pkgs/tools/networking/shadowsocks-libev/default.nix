{ stdenv, fetchurl, fetchgit, cmake
, libsodium, mbedtls, libev, c-ares, pcre
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt
}:

stdenv.mkDerivation rec {
  name = "shadowsocks-libev-${version}";
  version = "3.1.3";

  # Git tag includes CMake build files which are much more convenient.
  # fetchgit because submodules.
  src = fetchgit {
    url = "https://github.com/shadowsocks/shadowsocks-libev";
    rev = "refs/tags/v${version}";
    sha256 = "16q91xh6ixfv7b5rl31an11101irv08119klfx5qgj4i6h7c41s7";
  };

  buildInputs = [ libsodium mbedtls libev c-ares pcre ];
  nativeBuildInputs = [ cmake asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt ];

  cmakeFlags = [ "-DWITH_STATIC=OFF" ];

  postInstall = ''
    cp lib/* $out/lib
    chmod +x $out/bin/*
    mv $out/pkgconfig $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.
      It is a port of Shadowsocks created by @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = https://github.com/shadowsocks/shadowsocks-libev;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.nfjinjing ];
    platforms = platforms.linux;
  };
}
