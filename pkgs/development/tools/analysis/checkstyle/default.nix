{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "6.3";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/checkstyle/${version}/${name}-bin.tar.gz";
    sha256 = "181wm6yxyf9dsp1dgy7bpjz5j72a5fc818293k5mxr8g1gf0s3f4";
  };

  installPhase = ''
    mkdir -p $out/checkstyle
    cp -R * $out/checkstyle
  '';

  meta = with stdenv.lib; {
    description = "Checks Java source against a coding standard";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = http://checkstyle.sourceforge.net/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pSub ];
  };
}
