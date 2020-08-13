{ stdenv, fetchurl, jre }:
let
  mcVersion = "1.16.1";
  buildNum = "135";
  jar = fetchurl {
    url = "https://papermc.io/api/v1/paper/${mcVersion}/${buildNum}/download";
    sha256 = "0vh7bqvbfjmb3d1di2i3rx82fjh1mdnisqfxizamzaqq90ffh6rx";
  };
in stdenv.mkDerivation {
  pname = "papermc";
  version = "${mcVersion}r${buildNum}";

  preferLocalBuild = true;

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${jar} $out/papermc.jar
    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/papermc.jar nogui
    EOF
    chmod +x $out/bin/minecraft-server
  '';

  phases = "installPhase";

  meta = {
    description = "High-performance Minecraft Server";
    homepage    = "https://papermc.io/";
    license     = stdenv.lib.licenses.gpl3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ aaronjanse ];
  };
}
