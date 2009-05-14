{stdenv, fetchurl, SDL, SDL_mixer, unzip, libvorbis, mesa, gtk, pkgconfig, nasm, makeDesktopItem}:

stdenv.mkDerivation rec {
  name = "eduke32";
  
  src = fetchurl {
    url = http://wiki.eduke32.com/stuff/source_code/eduke32_src_20090131.zip;
    sha256 = "e6b8cc2c7e0c32a6aa5a64359be8b8c494dcae08dda87e1de718c030426ef74d";
  };
  
  buildInputs = [ unzip SDL SDL_mixer libvorbis mesa gtk pkgconfig ]
    ++ stdenv.lib.optional (stdenv.system == "i686-linux") nasm;
  
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
    
    if [ "$EDUKE32_DATA_DIR" = "" ]
    then 
        EDUKE32_DATA_DIR=/var/games/eduke32
    fi
    if [ "$EDUKE32_CON_FILE" = "" ]
    then
        EDUKE32_CON_FILE=\$EDUKE32_DATA_DIR/GAME.CON
    fi
    if [ "$EDUKE32_GRP_FILE" = "" ]
    then
        EDUKE32_GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi
    
    cd \$EDUKE32_DATA_DIR
    eduke32 /x\$EDUKE32_CON_FILE /g\$EDUKE32_GRP_FILE    
    EOF
    chmod 755 $out/bin/eduke32-wrapper
    
    # Install desktop item
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
}
