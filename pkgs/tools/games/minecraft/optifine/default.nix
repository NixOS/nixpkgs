{ lib
, stdenv
, fetchurl
, makeWrapper
, jre }:

stdenv.mkDerivation rec {
  pname = "optifine";
  version = "1.16.5_HD_U_G8";

  src = fetchurl {
    url = "https://optifine.net/download?f=OptiFine_${version}.jar";
    sha256 = "0ks91d6n4vkgb5ykdrc67br2c69nqjr0xhp7rrkybg24xn8bqxiw";
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
