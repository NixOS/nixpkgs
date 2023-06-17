{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "fabric-installer";
  version = "0.11.2";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${version}/fabric-installer-${version}.jar";
    sha256 = "sha256-xq1b7xuxK1pyJ74+5UDCyQav30rIEUt44KygsUYAXCc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib/fabric}

    cp $src $out/lib/fabric/fabric-installer.jar
    makeWrapper ${jre}/bin/java $out/bin/fabric-installer \
      --add-flags "-jar $out/lib/fabric/fabric-installer.jar"
  '';

  meta = with lib; {
    homepage = "https://fabricmc.net/";
    description = "A lightweight, experimental modding toolchain for Minecraft";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
