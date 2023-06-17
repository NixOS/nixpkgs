{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "opengrok";
  version = "1.12.9";

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-8VyCMFFL85qqnkO66qobB0OzF8DWfpjkc8Jxbp8FtH0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out/
    makeWrapper ${jre}/bin/java $out/bin/opengrok \
      --add-flags "-jar $out/lib/opengrok.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Source code search and cross reference engine";
    homepage = "https://opengrok.github.io/OpenGrok/";
    changelog = "https://github.com/oracle/opengrok/releases/tag/${version}";
    license = licenses.cddl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
