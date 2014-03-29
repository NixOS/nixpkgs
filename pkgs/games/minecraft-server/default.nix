{ stdenv, fetchurl, jre }:

with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name    = "minecraft-server-${version}";
  version = "1.7.5";

  src  = fetchurl {
    url    = "http://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar";
    sha256 = "0f3sh3fws02yl4xqa8qrvn0cchfp0hymqrf30c5syzzcz9w4l8pq";
  };

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';

  phases = "installPhase";

  meta = {
    description = "Minecraft Server";
    homepage    = "https://minecraft.net";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
