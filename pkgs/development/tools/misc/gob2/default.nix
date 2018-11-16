{ stdenv, fetchurl, pkgconfig, glib, bison, flex }:

stdenv.mkDerivation rec {
  name = "gob2-${minVer}.20";
  minVer = "2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gob2/${minVer}/${name}.tar.xz";
    sha256 = "5fe5d7990fd65b0d4b617ba894408ebaa6df453f2781c15a1cfdf2956c0c5428";
  };

  # configure script looks for d-bus but it is only needed for tests
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib bison flex ];

  meta = {
    description = "Preprocessor for making GObjects with inline C code";
    homepage = https://www.jirka.org/gob.html;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
