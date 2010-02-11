{stdenv, fetchsvn, SDL, SDL_mixer, unzip, libvorbis, mesa, gtk, pkgconfig, nasm, makeDesktopItem}:

stdenv.mkDerivation rec {
  name = "eduke32";
  
  src = fetchsvn {
    url = https://eduke32.svn.sourceforge.net/svnroot/eduke32/polymer/eduke32;
    rev = 1597;
    sha256 = "be917420d628584e1b950570f67332f66cee0d24edfcee39c7bd62e6b9456436";
  };
  
  buildInputs = [ unzip SDL SDL_mixer libvorbis mesa gtk pkgconfig ]
    ++ stdenv.lib.optional (stdenv.system == "i686-linux") nasm;
  
  NIX_LDFLAGS = "-lgcc_s";
  NIX_CFLAGS_COMPILE = "-I${SDL}/include/SDL";
  
  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "eduke32-wrapper";
    comment = "Duke Nukem 3D port";
    desktopName = "EDuke32";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };

  buildPhase = ''
    make OPTLEVEL=0
  '';

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
    if [ "$EDUKE32_GRP_FILE" = "" ]
    then
        EDUKE32_GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi
    
    cd \$EDUKE32_DATA_DIR
    eduke32 /g\$EDUKE32_GRP_FILE    
    EOF
    chmod 755 $out/bin/eduke32-wrapper
    
    # Install desktop item
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  meta = {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
