{ lib, stdenv, fetchurl, nixosTests, jre_headless }:
stdenv.mkDerivation {
  pname = "minecraft-server";
  version = "1.16.5";

  src = fetchurl {
    url = "https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar";
    # sha1 because that comes from mojang via api
    sha1 = "1b557e7b033b583cd9f66746b7a9ab1ec1673ced";
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

  passthru = {
    tests = { inherit (nixosTests) minecraft-server; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Minecraft Server";
    homepage = "https://minecraft.net";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tomberek costrouc ];
  };
}
