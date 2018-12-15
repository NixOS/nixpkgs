{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name    = "minecraft-server-${version}";
  version = "1.13.2";

  src  = fetchurl {
    # Old url
    # https://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar
    url    = "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar";
    sha256 = "13h8dxrrgqa1g6sd7aaw26779hcsqsyjm7xm0sknifn54lnamlzz";
  };

  preferLocalBuild = true;

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
    maintainers = [ stdenv.lib.maintainers.thoughtpolice stdenv.lib.maintainers.tomberek ];
  };
}
