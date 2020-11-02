{ stdenv, fetchurl, jre_headless }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16.4";

  src = fetchurl {
    url = "https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar";
    # sha1 because that comes from mojang via api
    sha1 = "35139deedbd5182953cf1caa23835da59ca3d7cd";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';

  phases = "installPhase";

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Minecraft Server";
    homepage = "https://minecraft.net";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tomberek costrouc ];
  };
}
