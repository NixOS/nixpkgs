{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "amidst";
  version = "4.7";

  src = fetchurl { # TODO: Compile from src
    url = "https://github.com/toolbox4minecraft/amidst/releases/download/v${version}/amidst-v${lib.replaceStrings [ "." ] [ "-" ] version}.jar";
    sha256 = "sha256-oecRjD7JUuvFym8N/hSE5cbAFQojS6yxOuxpwWRlW9M=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib/amidst}
    cp $src $out/lib/amidst/amidst.jar
    makeWrapper ${jre}/bin/java $out/bin/amidst \
      --add-flags "-jar $out/lib/amidst/amidst.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/toolbox4minecraft/amidst";
    description = "Advanced Minecraft Interface and Data/Structure Tracking";
    mainProgram = "amidst";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
