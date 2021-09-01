{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "fabric-installer";
  version = "0.7.4";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${version}/fabric-installer-${version}.jar";
    sha256 = "0s3nmwpq1qg90c27qh4anvvsg4yzsgcp6kwsb35fsiaaakxn0b8r";
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
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
