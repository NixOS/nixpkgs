{ stdenv, fetchurl, jre }:
let
  mcVersion = "1.16.1";
  buildNum = "114";
  jar = fetchurl {
    url = "https://papermc.io/api/v1/paper/${mcVersion}/${buildNum}/download";
    sha256 = "1n144v89fncdbghgz2r2ky783zb2gil24f7fs84lkz1v70r5cm8n";
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
