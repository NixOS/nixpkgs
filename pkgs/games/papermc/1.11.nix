{ lib
, stdenv
, fetchurl
, bash
, adoptopenjdk-jre-hotspot-bin-13
}:

# NOTE: Does not work with the current minecraft-server module.
let
  mcVersion = "1.11.2";
  buildNum = "1106";
  jar = fetchurl {
    url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
    sha256 = "PQ9A7B+WMN/br6YmzCDCZtf7kPwiWD3BuZXn+/t2gw0=";
  };
  jre = adoptopenjdk-jre-hotspot-bin-13;
in stdenv.mkDerivation {
  pname = "papermc";
  version = "${mcVersion}r${buildNum}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/papermc/papermc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "High-performance Minecraft Server";
    homepage    = "https://papermc.io/";
    license     = lib.licenses.gpl3Only;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alexnortung
    ];
  };
}

