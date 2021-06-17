{ lib
, stdenv
, fetchurl
, makeWrapper
, jre8 }: # TODO: Update this to the latest version of java upon the next release. This is currently not done because of https://github.com/toolbox4minecraft/amidst/issues/960

stdenv.mkDerivation rec {
  pname = "amidst";
  version = "4.7";

  src = fetchurl { # TODO: Compile from src
    url = "https://github.com/toolbox4minecraft/amidst/releases/download/v${version}/amidst-v${lib.replaceStrings [ "." ] [ "-" ] version}.jar";
    sha256 = "sha256-oecRjD7JUuvFym8N/hSE5cbAFQojS6yxOuxpwWRlW9M=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jre8 makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib/amidst}
    cp $src $out/lib/amidst/amidst.jar
    makeWrapper ${jre8}/bin/java $out/bin/amidst \
      --add-flags "-jar $out/lib/amidst/amidst.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/toolbox4minecraft/amidst";
    description = "Advanced Minecraft Interface and Data/Structure Tracking";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.linux;
  };
}
