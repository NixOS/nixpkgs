{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "opengrok";
  version = "1.9.2";

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-z5jqKRnxPOwj1sOFGt0m54m9t0l3xBfulvmQCYeJj40=";
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
    license = licenses.cddl;
    maintainers = [ ];
  };
}
