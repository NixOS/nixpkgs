{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "5.7";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/checkstyle/${version}/${name}-bin.tar.gz";
    sha256 = "0kzj507ylynq6p7v097bjzsckkjny5i2fxwxyrlwi5samhi2m06x";
  };

  installPhase = ''
    mkdir -p $out/checkstyle
    cp -R * $out/checkstyle
  '';

  meta = {
    description = "Checks Java source against a coding standard";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = http://checkstyle.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
