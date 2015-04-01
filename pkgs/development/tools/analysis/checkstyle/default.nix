{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "6.4.1";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/checkstyle/${version}/${name}-bin.tar.gz";
    sha256 = "0w41h5m51mfswdrqpgyjs73x4qr73scswv34f5zwckcih4dvsdzz";
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
