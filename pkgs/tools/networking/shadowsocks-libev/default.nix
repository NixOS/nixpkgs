{ stdenv, fetchFromGitHub, cmake
, libsodium, mbedtls, libev, c-ares, pcre
, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, libxslt
}:

stdenv.mkDerivation rec {
  pname = "shadowsocks-libev";
  version = "3.3.0";

  # Git tag includes CMake build files which are much more convenient.
  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0f6fk7p49b1m78v4ipacbl522nma9b3qzrvihzp2mmsa6j3cysgr";
    fetchSubmodules = true;
  };

  buildInputs = [ libsodium mbedtls libev c-ares pcre ];
  nativeBuildInputs = [ cmake asciidoc xmlto docbook_xml_dtd_45
                        docbook_xsl libxslt ];

  cmakeFlags = [ "-DWITH_STATIC=OFF"  "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON" ];

  postInstall = ''
    cp lib/* $out/lib
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
