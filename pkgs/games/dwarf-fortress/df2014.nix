{ stdenv, fetchgit, fetchurl, cmake, glew, ncurses, SDL, SDL_image, SDL_ttf, gtk2, glib, mesa, openal, pango, atk, gdk_pixbuf, glibc, libsndfile
  , copyDataDirectory ? true }:

/* set copyDataDirectory as true by default since df 40 does not seem to run without it */

let

  srcs = {
    df_unfuck = fetchgit {
      url = "https://github.com/svenstaro/dwarf_fortress_unfuck";
      rev = "4681508dd799aaf20b47c2ac0e9da18fa4876993";
      sha256 = "16495214a19742cb97351109b124ad9d691ee52bbb1b86c9c1907978734b5ca0";
    };

    df = fetchurl {
      url = "http://www.bay12games.com/dwarves/df_40_10_linux.tar.bz2";
      sha256 = "0hfm4395y0lacgsl7wqr6vwcw42pqm03xp7giqfk3mfsn32wqnm7";
    };
  };

in

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "dwarf-fortress-0.40.10";


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
      license = "unfree-redistributable";
      maintainers = [stdenv.lib.maintainers.roconnor];
  };
}
