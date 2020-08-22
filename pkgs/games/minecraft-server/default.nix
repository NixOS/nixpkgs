{ stdenv, fetchurl, jre_headless }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16.2";

  src = fetchurl {
    url = "https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar";
    # sha1 because that comes from mojang via api
    sha1 = "c5f6fb23c3876461d46ec380421e42b289789530";
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
