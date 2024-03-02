{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "opengrok";
  version = "1.13.4";

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-NtBNsCWcnRqJlhIy8VQX54Jzj1KegZOjKS5z2QG3NOI=";
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
