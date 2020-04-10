{ stdenv, fetchurl, autoconf, automake, libtool, autoreconfHook}:

stdenv.mkDerivation rec {
  pname = "CUnit";
  version = "2.1-3";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [autoconf automake libtool];

  src = fetchurl {
    url = "mirror://sourceforge/cunit/CUnit/${version}/${pname}-${version}.tar.bz2";
    sha256 = "057j82da9vv4li4z5ri3227ybd18nzyq81f6gsvhifs5z0vr3cpm";
  };

  meta = {
    description = "A Unit Testing Framework for C";

    longDescription = ''
      CUnit is a lightweight system for writing, administering, and running
      unit tests in C.  It provides C programmers a basic testing functionality
      with a flexible variety of user interfaces.
    '';

    homepage = "http://cunit.sourceforge.net/";

    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
