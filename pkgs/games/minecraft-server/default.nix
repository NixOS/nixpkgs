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
  minecraft-server_1_13_2 = common {
    version = "1.13.2";
    url    = "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar";
    sha256 = "13h8dxrrgqa1g6sd7aaw26779hcsqsyjm7xm0sknifn54lnamlzz";
  };

  minecraft-server_1_13_1 = common {
    version = "1.13.1";
    url = "https://launcher.mojang.com/mc/game/1.13.1/server/fe123682e9cb30031eae351764f653500b7396c9/server.jar";
    sha256 = "1lak29b7dm0w1cmzjn9gyix6qkszwg8xgb20hci2ki2ifrz099if";
  };

  minecraft-server_1_13_0 = common {
    version = "1.13.0";
    url = "https://launcher.mojang.com/mc/game/1.13/server/d0caafb8438ebd206f99930cfaecfa6c9a13dca0/server.jar";
    sha256 = "1fahqnylxzbvc0fdsqk0x15z40mcc5b7shrckab1qcsdj0kkjvz7";
  };

  minecraft-server_1_12_2 = common {
    version = "1.12.2";
    url = "https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/minecraft_server.1.12.2.jar";
    sha256 = "0zhnac6yvkdgdaag0gb0fgrkgizbwrpf7s76yqdiknfswrs947zy";
  };

}
