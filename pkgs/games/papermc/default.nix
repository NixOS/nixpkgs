{ stdenv, fetchurl, jre }:
let
  mcVersion = "1.16.2";
  buildNum = "141";
  jar = fetchurl {
    url = "https://papermc.io/api/v1/paper/${mcVersion}/${buildNum}/download";
    sha256 = "1qhhnaysw9r73fpvj9qcmjah722a6a4s6g4cblna56n1hpz4lw1s";
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
