{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "wiremock";
  version = "2.35.0";
  src = fetchurl {
    url = "mirror://maven/com/github/tomakehurst/wiremock-jre8-standalone/${version}/wiremock-jre8-standalone-${version}.jar";
    hash = "sha256-rhVq4oEuPPpHDEftBzEA707HeSc3Kk4gPw471THz61c=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out"/{share/wiremock,bin}
    cp ${src} "$out/share/wiremock/wiremock.jar"

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/wiremock/wiremock.jar"
  '';

  meta = {
    description = "A flexible tool for building mock APIs";
    homepage = "https://wiremock.org/";
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
  };
}
