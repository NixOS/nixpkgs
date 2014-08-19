{ stdenv, fetchurlGnome, pkgconfig, glib, bison, flex }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "gob2";
    major = "2"; minor = "0"; patchlevel = "18"; extension = "gz";
    sha256 = "1r242s3rsxyqiw2ic2gdpvvrx903jgjd1aa4mkl26in5k9zk76fa";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ glib bison flex pkgconfig ];

  meta = {
    description = "Preprocessor for making GObjects with inline C code";
    homepage = http://www.jirka.org/gob.html;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
