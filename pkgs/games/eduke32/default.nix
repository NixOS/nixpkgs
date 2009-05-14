{stdenv, fetchurl, SDL, SDL_mixer, unzip, libvorbis, mesa, gtk, pkgconfig, makeDesktopItem}:

stdenv.mkDerivation rec {
  name = "eduke32";
  src = fetchurl {
    url = http://wiki.eduke32.com/stuff/source_code/eduke32_src_20090131.zip;
    sha256 = "e6b8cc2c7e0c32a6aa5a64359be8b8c494dcae08dda87e1de718c030426ef74d";
  };
  buildInputs = [ unzip SDL SDL_mixer libvorbis mesa gtk pkgconfig ];
  NIX_LDFLAGS = "-lgcc_s";
  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "eduke32-wrapper";
    comment = "Duke Nukem 3D port";
    desktopName = "EDuke32";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };
    
  installPhase = ''
    # Install binaries
    ensureDir $out/bin
    cp eduke32 mapster32 $out/bin 
    
    # Make wrapper script
    cat > $out/bin/eduke32-wrapper <<EOF
    #!/bin/sh
    
    if [ -f ~/.eduke32-settings ]
    then
        .  ~/.eduke32-settings
    else
       EDUKE32_DATA_DIR=/var/eduke32
       CON_FILE=\$EDUKE32_DATA_DIR/GAME.CON
       GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi
    
    cd \$EDUKE32_DATA_DIR
    eduke32 /x\$CON_FILE /g\$GRP_FILE    
    EOF
    chmod 755 $out/bin/eduke32-wrapper
    
    # Install desktop item
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
}
