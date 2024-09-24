{ lib, stdenv, fetchurl, jre8, unzip }:

stdenv.mkDerivation rec {
  pname = "galen";
  version = "2.4.4";

  inherit jre8;

  src = fetchurl {
    url = "https://github.com/galenframework/galen/releases/download/galen-${version}/galen-bin-${version}.zip";
    sha256 = "13dq8cf0yy24vym6z7p8hb0mybgpcl4j5crsaq8a6pjfxz6d17mq";
  };

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
  mkdir -p $out/bin
  '';

  installPhase = ''
  cat galen | sed -e "s,java,$jre8/bin/java," > $out/bin/galen
  chmod +x $out/bin/galen
  cp galen.jar $out/bin
  '';

  meta = with lib; {
    homepage = "http://galenframework.com";
    description = "Automated layout testing for websites";
    mainProgram = "galen";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
