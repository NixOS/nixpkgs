{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name    = "minecraft-server-${version}";
  version = "1.11.2";

  src  = fetchurl {
    url    = "http://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar";
    sha256 = "12nqcj6skwjfcywm3ah4jb1qn4r558ng9cchdc3hbz99nhv7vi6y";
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
