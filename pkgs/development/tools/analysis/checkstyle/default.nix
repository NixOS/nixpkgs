{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "10.3.2";
  pname = "checkstyle";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
    sha256 = "sha256-VrTjpw/bT5n/ydUt9sK/cGqSi9gZJq1TsRupfm7RS1M=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/checkstyle/checkstyle-all.jar
    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/checkstyle/checkstyle-all.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Checks Java source against a coding standard";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = "http://checkstyle.sourceforge.net/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pSub ];
    platforms = jre.meta.platforms;
  };
}
