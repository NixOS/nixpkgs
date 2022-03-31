{ lib, stdenv, fetchurl, nixosTests, jre_headless, version, url, sha256 }:
stdenv.mkDerivation {
  pname = "minecraft-fabric-server";
  inherit version;

  src = fetchurl { inherit url sha256; };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/fabric-server.jar

    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/fabric-server.jar nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';

  dontUnpack = true;

  passthru = {
    tests = { inherit (nixosTests) minecraft-server; };
  };

  meta = with lib; {
    description = "Minecraft 1.18.2 server with Fabric modloader";
    homepage = "https://fabricmc.net";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tomberek costrouc jyooru ];
  };
}
