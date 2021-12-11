{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "fabric-installer";
  version = "0.10.2";

  src = fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${version}/fabric-installer-${version}.jar";
    sha256 = "sha256-xjnL1nURAr4z2OZKEqiC/E6+rSvDpxrfGwm/5Bvxxno=";
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
