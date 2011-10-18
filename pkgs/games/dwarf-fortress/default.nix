{stdenv, fetchurl, SDL, SDL_image, SDL_ttf, gnomegtk, glib, mesa, openal, glibc, libsndfile}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "dwarf-fortress-0.31.25";

  src = fetchurl {
    url = "http://www.bay12games.com/dwarves/df_31_25_linux.tar.bz2";
    sha256 = "0d3klvf5n99j38pdhx9mak78px65aw47smck82jb92la97drmcg3";
  };

  phases = "unpackPhase patchPhase installPhase";

  /* :TODO: Game options should be configurable by patching the default configuration files */

  permission = ./df_permission;

  installPhase = ''
    set -x
    ensureDir $out/bin
    ensureDir $out/share/df_linux
    cp -r * $out/share/df_linux
    cp $permission $out/share/df_linux/nix_permission
 
    patchelf --set-interpreter ${glibc}/lib/ld-linux.so.2 $out/share/df_linux/libs/Dwarf_Fortress
    ln -s ${libsndfile}/lib/libsndfile.so $out/share/df_linux/libs/
          
    cat > $out/bin/dwarf-fortress << EOF
    #!${stdenv.shell}
    export DF_DIR="\$HOME/.config/df_linux"
    if [ -n "\$XDG_DATA_HOME" ]
     then export DF_DIR="\$XDG_DATA_HOME/df_linux"
    fi

    # Recreate a directory sturctor reflecting the original distribution in the user directory

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

    # index initial_movies, announcement, dipscript and help files are as of 0.31.16 opened in read/write mode instead of read-only mode
    # this is a hack to work around this
    # Should I just apply this to the whole data directory?
    for i in index initial_movies announcement dipscript help
    do
     rm \$DF_DIR/data/\$i
     cp -rf $out/share/df_linux/data/\$i \$DF_DIR/data/
     chmod -R u+w \$DF_DIR/data/\$i
    done

    # link in persistant data
    mkdir -p \$DF_DIR/save
    ln -s \$DF_DIR/save \$DF_DIR/data/

    # now run Dwarf Fortress! 
    export LD_LIBRARY_PATH=\$DF_DIR/df_linux/libs/:${SDL}/lib:${SDL_image}/lib/:${SDL_ttf}/lib/:${gnomegtk}/lib/:${glib}/lib/:${mesa}/lib/:${openal}/lib/
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
