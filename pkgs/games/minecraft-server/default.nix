{ stdenv, fetchurl, jre }:

let
  common = { version, sha256, url }:
    stdenv.mkDerivation (rec {
      name = "minecraft-server-${version}";
      inherit version;

      src = fetchurl {
        inherit url sha256;
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
        maintainers = with stdenv.lib.maintainers; [ thoughtpolice tomberek costrouc];
      };
    });

in {
  minecraft-server_1_14 = common {
    version = "1.14";
    url    = "https://launcher.mojang.com/v1/objects/f1a0073671057f01aa843443fef34330281333ce/server.jar";
    sha256 = "671e3d334dd601c520bf1aeb96e49038145172bef16bc6c418e969fd8bf8ff6c";
  };

  minecraft-server_1_13_2 = common {
    version = "1.13.2";
    url    = "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar";
    sha256 = "13h8dxrrgqa1g6sd7aaw26779hcsqsyjm7xm0sknifn54lnamlzz";
  };

  minecraft-server_1_12_2 = common {
    version = "1.12.2";
    url = "https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/minecraft_server.1.12.2.jar";
    sha256 = "0zhnac6yvkdgdaag0gb0fgrkgizbwrpf7s76yqdiknfswrs947zy";
  };

}
