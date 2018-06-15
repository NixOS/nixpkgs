{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "8.10.1";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/checkstyle/${name}-bin.tar.gz";
    sha256 = "18i1a6v9dg08in68g584y7bhf76g59pp8lyixqc3v6wgj3ksv8q9";
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
    platforms = with platforms; linux;
  };
}
