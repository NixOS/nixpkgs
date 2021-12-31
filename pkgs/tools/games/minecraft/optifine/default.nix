{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "optifine";
  version = "1.18.1_HD_U_H4";

  src = fetchurl {
    url = "https://optifine.net/download?f=OptiFine_${version}.jar";
    sha256 = "325168569b21a2dcde82999876f69ec9d8af75202a7021691f2abede4d81dcec";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib/optifine}
    cp $src $out/lib/optifine/optifine.jar

    makeWrapper ${jre}/bin/java $out/bin/optifine \
      --add-flags "-jar $out/lib/optifine/optifine.jar"
  '';

  meta = with lib; {
    homepage = "https://optifine.net/";
    description = "A Minecraft optimization mod";
    longDescription = ''
      OptiFine is a Minecraft optimization mod.
      It allows Minecraft to run faster and look better with full support for HD textures and many configuration options.
    '';
    license = licenses.unfree;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
