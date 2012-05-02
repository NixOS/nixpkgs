{stdenv, fetchurl, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa, openal}:

stdenv.mkDerivation {
  name = "minecraft-1.2.5";

  src = fetchurl {
    url = "https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft.jar";
    sha256 = "0yp3wgy93wm746dkv6kbljhmzdqbcg4qhwkvnaaq4ml84mvvjp38";
  };

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v $src $out/minecraft.jar

    cat > $out/bin/minecraft << EOF
    #!${stdenv.shell}

    # wrapper for minecraft
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${jre}/lib/${jre.architecture}/:${libX11}/lib/:${libXext}/lib/:${libXcursor}/lib/:${libXrandr}/lib/:${libXxf86vm}/lib/:${mesa}/lib/:${openal}/lib/
    ${jre}/bin/java -jar $out/minecraft.jar
    EOF

    chmod +x $out/bin/minecraft
  '';

  meta = {
      description = "A sandbox-building game";
      homepage = http://www.minecraft.net;
      maintainers = [ "Carles Pagès <page@cubata.homelinux.net>" stdenv.lib.maintainers.shlevy ];
      license = "unfree-redistributable";
  };
}
