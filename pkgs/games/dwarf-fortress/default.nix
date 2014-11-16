{ stdenv, fetchgit, fetchurl, cmake, glew, ncurses, SDL, SDL_image, SDL_ttf, gtk2, glib, mesa, openal, pango, atk, gdk_pixbuf, glibc, libsndfile
  , copyDataDirectory ? true }:

/* set copyDataDirectory as true by default since df 40 does not seem to run without it */

let

  srcs = {
    df_unfuck = fetchgit {
      url = "https://github.com/svenstaro/dwarf_fortress_unfuck";
      rev = "7c1d8bf027c8d8835d0d3ef50502f0c45a7f9bae";
      sha256 = "d4a681231da00fec7bcdb092bcf51415c75fd20fc9da786fb6013e0c03fbc373";
    };

    df = fetchurl {
      url = "http://www.bay12games.com/dwarves/df_40_15_linux.tar.bz2";
      sha256 = "1mmz7mnsm2y5n2aqyf30zrflyl58haaj6p380pi4022gbd13mnsn";
    };
  };

in

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "dwarf-fortress-0.40.15";


  buildInputs = [ SDL SDL_image SDL_ttf gtk2 glib glew mesa ncurses openal glibc libsndfile pango atk cmake gdk_pixbuf];
  src = "${srcs.df_unfuck} ${srcs.df}";
  phases = "unpackPhase patchPhase configurePhase buildPhase installPhase";

  sourceRoot = "git-export";

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include"
  ];

  /* :TODO: Game options should be configurable by patching the default configuration files */

  permission = ./df_permission;

  installPhase = ''
    set -x
    mkdir -p $out/bin
    mkdir -p $out/share/df_linux
    cd ../../
    cp -r ./df_linux/* $out/share/df_linux
    rm $out/share/df_linux/libs/lib*
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc stdenv.glibc ]}:$out/share/df_linux/libs"  $out/share/df_linux/libs/Dwarf_Fortress
    cp -f ./git-export/build/libgraphics.so $out/share/df_linux/libs/libgraphics.so

    cp $permission $out/share/df_linux/nix_permission

    patchelf --set-interpreter ${glibc}/lib/ld-linux.so.2 $out/share/df_linux/libs/Dwarf_Fortress

    cat > $out/bin/dwarf-fortress << EOF
    #!${stdenv.shell}
    export DF_DIR="\$HOME/.config/df_linux"
    if [ -n "\$XDG_DATA_HOME" ]
     then export DF_DIR="\$XDG_DATA_HOME/df_linux"
    fi

    # Recreate a directory structure reflecting the original
    # distribution in the user directory (for modding support)
    ${if copyDataDirectory then ''
      if [ ! -d "\$DF_DIR" ];
      then
        mkdir -p \$DF_DIR
        cp -r $out/share/df_linux/* \$DF_DIR/
        chmod -R u+rw \$DF_DIR/
      fi
    '' else ''
      # Link in the static stuff
      mkdir -p \$DF_DIR
      ln -sf $out/share/df_linux/libs \$DF_DIR/
      ln -sf $out/share/df_linux/raw \$DF_DIR/
      ln -sf $out/share/df_linux/df \$DF_DIR/

      # Delete old data directory
      rm -rf \$DF_DIR/data

      # Link in the static data directory
      mkdir \$DF_DIR/data
      for i in $out/share/df_linux/data/*
      do
       ln -s \$i \$DF_DIR/data/
      done

      # link in persistant data
      mkdir -p \$DF_DIR/save
      ln -s \$DF_DIR/save \$DF_DIR/data/
    ''}

    # now run Dwarf Fortress!
    export LD_LIBRARY_PATH=\${stdenv.gcc}/lib:${SDL}/lib:${SDL_image}/lib/:${SDL_ttf}/lib/:${gtk2}/lib/:${glib}/lib/:${mesa}/lib/:${openal}/lib/:${libsndfile}/lib:$DF_DIR/df_linux/libs/
    \$DF_DIR/df "\$@"
    EOF

    chmod +x $out/bin/dwarf-fortress
  '';

  meta = {
      description = "control a dwarven outpost or an adventurer in a randomly generated, persistent world";
      homepage = http://www.bay12games.com/dwarves;
      license = stdenv.lib.licenses.unfreeRedistributable;
      maintainers = [stdenv.lib.maintainers.roconnor];
  };
}
