{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "8.11";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
    sha256 = "13x4m4rn7rix64baclcm2jqbizkj38njif2ba0ycmvyjm62smfwv";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/checkstyle
    cp $src $out/checkstyle/checkstyle-all.jar
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
