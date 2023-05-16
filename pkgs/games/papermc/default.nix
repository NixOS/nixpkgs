{ lib, stdenv, fetchurl, bash, jre }:

stdenv.mkDerivation rec {
  pname = "papermc";
<<<<<<< HEAD
  version = "1.20.1.83";
=======
  version = "1.19.3.375";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  jar = let
    mcVersion = lib.versions.pad 3 version;
    buildNum = builtins.elemAt (lib.versions.splitVersion version) 3;
  in fetchurl {
    url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
<<<<<<< HEAD
    sha256 = "sha256-HQpc3MOXa1wkXqgm9ciQj04FUIyuupnYiu+2RZ/sXE4=";
=======
    sha256 = "sha256-NAl4+mCkO6xQQpIx2pd9tYX2N8VQa+2dmFwyBNbDa10=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/papermc/papermc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "High-performance Minecraft Server";
    homepage    = "https://papermc.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.gpl3Only;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaronjanse neonfuz ];
    mainProgram = "minecraft-server";
  };
}
