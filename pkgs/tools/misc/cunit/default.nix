{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "CUnit-2.1-2";

  src = fetchurl {
    url = "mirror://sourceforge/cunit/${name}-src.tar.bz2";
    sha256 = "1slb2sybv886ys0qqikb8lzn0h9jcqfrv64lakdxmqbgncq5yw0z";
  };

  meta = {
    description = "A Unit Testing Framework for C";

    longDescription = ''
      CUnit is a lightweight system for writing, administering, and running
      unit tests in C.  It provides C programmers a basic testing functionality
      with a flexible variety of user interfaces.
    '';

    homepage = http://cunit.sourceforge.net/;

    license = stdenv.lib.licenses.lgpl2;
  };
}
