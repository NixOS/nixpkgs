{ stdenv, fetchgit, cmake
, libsodium, mbedtls, libev, c-ares, pcre
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt
}:

stdenv.mkDerivation rec {
  name = "shadowsocks-libev-${version}";
  version = "3.2.0";

  # Git tag includes CMake build files which are much more convenient.
  # fetchgit because submodules.
  src = fetchgit {
    url = "https://github.com/shadowsocks/shadowsocks-libev";
    rev = "refs/tags/v${version}";
    sha256 = "0i9vz5b2c2bkdl2k9kqzvqyrlpdl94lf7k7rzxds8hn2kk0jizhb";
  };

  buildInputs = [ libsodium mbedtls libev c-ares pcre ];
  nativeBuildInputs = [ cmake asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt ];

  cmakeFlags = [ "-DWITH_STATIC=OFF" ];

  postInstall = ''
    cp lib/* $out/lib
    chmod +x $out/bin/*
    mv $out/pkgconfig $out/lib

    ${stdenv.lib.optionalString stdenv.isDarwin ''
      install_name_tool -change libcork.dylib $out/lib/libcork.dylib $out/lib/libipset.dylib
      install_name_tool -change libbloom.dylib $out/lib/libbloom.dylib $out/lib/libipset.dylib

      for exe in $out/bin/*; do
        install_name_tool -change libmbedtls.dylib ${mbedtls}/lib/libmbedtls.dylib $exe
        install_name_tool -change libmbedcrypto.dylib ${mbedtls}/lib/libmbedcrypto.dylib $exe
        install_name_tool -change libcork.dylib $out/lib/libcork.dylib $exe
        install_name_tool -change libipset.dylib $out/lib/libipset.dylib $exe
        install_name_tool -change libbloom.dylib $out/lib/libbloom.dylib $exe
      done
    ''}
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
    platforms = platforms.all;
  };
}
