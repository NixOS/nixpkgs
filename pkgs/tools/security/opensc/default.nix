{ stdenv, fetchurl, libtool, readline, zlib, openssl, libiconvOrNull, pcsclite
, libassuan1, pkgconfig, libXt, docbook_xsl, libxslt, docbook_xml_dtd_412
}:

stdenv.mkDerivation rec {
  name = "opensc-0.13.0";

  src = fetchurl {
    url = "mirror://sourceforge/opensc/${name}.tar.gz";
    sha256 = "054v11yc2lqlfqs556liw18klhkx9zyjylqcwirk4axiafp4dpmb";
  };

  buildInputs = [ libtool readline zlib openssl pcsclite libassuan1 pkgconfig
    libXt libxslt libiconvOrNull docbook_xml_dtd_412
  ];

  configureFlags = [
    "--enable-doc"
    "--enable-man"
    "--enable-openssl"
    "--enable-pcsc"
    "--enable-readline"
    "--enable-sm"
    "--enable-zlib"
    "--with-pcsc-provider=${pcsclite}/lib/libpcsclite.so.1"
    "--with-xsl-stylesheetsdir=${docbook_xsl}/xml/xsl/docbook"
  ];

  meta = {
    description = "Set of libraries and utilities to access smart cards";
    homepage = "https://github.com/OpenSC/OpenSC/wiki";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
