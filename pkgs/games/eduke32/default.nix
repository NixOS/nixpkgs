{stdenv, fetchurl, SDL, SDL_mixer, libvorbis, mesa, gtk, pkgconfig, nasm, libvpx, flac, makeDesktopItem}:

stdenv.mkDerivation rec {
  name = "eduke32-20130303-3542";
  
  src = fetchurl {
    url = http://dukeworld.duke4.net/eduke32/synthesis/20130303-3542/eduke32_src_20130303-3542.tar.bz2;
    sha256 = "0v1q2bkmpnac5l9x97nnlhrrb95518vmhxx48zv3ncvmpafl1mqc";
  };
  
  buildInputs = [ SDL SDL_mixer libvorbis mesa gtk pkgconfig libvpx flac ]
    ++ stdenv.lib.optional (stdenv.system == "i686-linux") nasm;
  
  NIX_CFLAGS_COMPILE = "-I${SDL}/include/SDL";
  NIX_LDFLAGS = "-L${SDL}/lib -lgcc_s";
  
  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "eduke32-wrapper";
    comment = "Duke Nukem 3D port";
    desktopName = "EDuke32";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };

  preConfigure = ''
    sed -i -e "s|/usr/bin/sdl-config|${SDL}/bin/sdl-config|" build/Makefile.shared
  '';
  
  buildPhase = ''
    make OPTLEVEL=0
  '';

  installPhase = ''
    # Install binaries
    mkdir -p $out/bin
    cp eduke32 mapster32 $out/bin 
    
    # Make wrapper script
    cat > $out/bin/eduke32-wrapper <<EOF
    #!/bin/sh
    
    if [ "$EDUKE32_DATA_DIR" = "" ]
    then 
        EDUKE32_DATA_DIR=/var/lib/games/eduke32
    fi
    if [ "$EDUKE32_GRP_FILE" = "" ]
    then
        EDUKE32_GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi
    
    cd \$EDUKE32_DATA_DIR
    eduke32 -g \$EDUKE32_GRP_FILE    
    EOF
    chmod 755 $out/bin/eduke32-wrapper
    
    # Install desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  meta = {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    license = "GPLv2+ and BUILD license";
    homepage = http://eduke32.com;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
