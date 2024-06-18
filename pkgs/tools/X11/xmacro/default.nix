{ lib, stdenv, fetchurl, libX11, libXtst, xorgproto, libXi }:

stdenv.mkDerivation rec {
  pname = "xmacro";
  version = "0.4.6";

  src = fetchurl {
    url = "http://download.sarine.nl/xmacro/${pname}-${version}.tar.gz";
    sha256 = "1p9jljxyn4j6piljiyi2xv6f8jhjbzhabprp8p0qmqxaxgdipi61";
  };

  preInstall = "echo -e 'install:\n	mkdir \${out}/bin;\n	cp xmacrorec2 xmacroplay \${out}/bin;' >>Makefile; ";

  buildInputs = [ libX11 libXtst xorgproto libXi ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
