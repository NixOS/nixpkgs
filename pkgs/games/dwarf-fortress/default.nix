{ stdenv, fetchgit, fetchurl, cmake, glew, ncurses
, SDL, SDL_image, SDL_ttf, gtk2, glib
, mesa, openal, pango, atk, gdk_pixbuf, glibc, libsndfile
# begin dfhack-only parameters
, XMLLibXML
, XMLLibXSLT
, perl
, zlib
# end dfhack-only parameters
, enableDFHack ? false
}:

let
  baseVersion = "40";
  patchVersion = "24";
  srcs = {
    df_unfuck = fetchgit {
      url = "https://github.com/svenstaro/dwarf_fortress_unfuck";
      rev = "39742d64d2886fb594d79e7cc4b98fb917f26811";
      sha256 = "19vwx6kpv1sf93bx5v8x47f7x2cgxsqk82v6j1a72sa3q7m5cpc7";
    };

    dfhack = fetchgit {
      url = "https://github.com/DFHack/dfhack.git";
      rev = "0849099f2083e100cae6f64940b4eff4c28ce2eb";
      sha256 = "0lnqrayi8hwfivkrxb7fw8lb6v95i04pskny1px7084n7nzvyv8b";
    };

    df = fetchurl {
      url = "http://www.bay12games.com/dwarves/df_${baseVersion}_${patchVersion}_linux.tar.bz2";
      sha256 = "0d4jrs45qj89vq9mjg7fxxhis7zivvb0vzjpmkk274b778kccdys";
    };
  };

  dfHackWorksWithCurrentVersion = true;
  dfHackEnabled = dfHackWorksWithCurrentVersion && enableDFHack;

in

assert stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "dwarf-fortress-0.${baseVersion}.${patchVersion}";

  inherit baseVersion patchVersion;

  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    gtk2
    glib
    glew
    mesa
    ncurses
    openal
    glibc
    libsndfile
    pango
    atk
    cmake
    gdk_pixbuf
    XMLLibXML
    XMLLibXSLT
    perl
    zlib
  ];
  src = "${srcs.df_unfuck} ${srcs.df}" + stdenv.lib.optionalString dfHackEnabled " ${srcs.dfhack}";

  sourceRoot = srcs.df_unfuck.name;
  dfHackSourceRoot = srcs.dfhack.name;

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include"
  ];

  permission = ./df_permission;
  dfHackTemplate = ./dwarf-fortress-hacked.in;
  dfHackRunTemplate = ./dfhack-run.in;
  dwarfFortressTemplate = ./dwarf-fortress.in;
  installDfDataToHome = ./install-df-data-to-home.sh;
  installDfhackDataToHome = ./install-dfhack-data-to-home.sh;
  installDfDataContentToHome = ./install-df-data-content-to-home.sh;
  exportLibsTemplate = ./export-libs.sh.in;
  exportWorkaround = ./export-workaround.sh;

  postUnpack = stdenv.lib.optionalString dfHackEnabled ''
    if [ "$dontMakeSourcesWritable" != 1 ]; then
      chmod -R u+w "$dfHackSourceRoot"
    fi
  '';

  preConfigure = stdenv.lib.optionalString dfHackEnabled ''
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$out/share/df_linux $cmakeFlags"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/build/depends/protobuf
  '';

  postConfigure = stdenv.lib.optionalString dfHackEnabled ''
    if [ -z "$originalSourceRoot" ]; then

      originalSourceRoot=$sourceRoot
      export sourceRoot=$dfHackSourceRoot

      pushd ../../$sourceRoot

      eval "''${configurePhase:-configurePhase}"

      popd

      export sourceRoot=$originalSourceRoot
      unset originalSourceRoot
    fi
  '';

  installPhase = ''
    set -x
    mkdir -p $out/bin
    mkdir -p $out/share/df_linux
    pushd ../../
    cp -r ./df_linux/* $out/share/df_linux
    rm $out/share/df_linux/libs/lib*

    # Store the original hash
    orig_hash=$(md5sum $out/share/df_linux/libs/Dwarf_Fortress | awk '{ print $1 }')
    echo $orig_hash | cut -c1-8 > $out/share/df_linux/hash.md5.orig  # for dwarf-therapist
    echo $orig_hash > $out/share/df_linux/full-hash-orig.md5  # for dfhack

    cp -f ./${srcs.df_unfuck.name}/build/libgraphics.so $out/share/df_linux/libs/libgraphics.so

    cp $permission $out/share/df_linux/nix_permission

    # Placeholder files for hashes of patched binary
    touch $out/share/df_linux/hash.md5.patched
    touch $out/share/df_linux/full-hash-patched.md5

    mkdir -p $out/share/df_linux/shell
    cp $installDfDataToHome $out/share/df_linux/shell/install-df-data-to-home.sh
    cp $installDfhackDataToHome $out/share/df_linux/shell/install-dfhack-data-to-home.sh
    cp $installDfDataContentToHome $out/share/df_linux/shell/install-df-data-content-to-home.sh
    cp $exportWorkaround $out/share/df_linux/shell/export-workaround.sh
    substitute $exportLibsTemplate $out/share/df_linux/shell/export-libs.sh \
        --subst-var-by stdenv_cc ${stdenv.cc} \
        --subst-var-by SDL ${SDL} \
        --subst-var-by SDL_image ${SDL_image} \
        --subst-var-by SDL_ttf ${SDL_ttf} \
        --subst-var-by gtk2 ${gtk2} \
        --subst-var-by glib ${glib} \
        --subst-var-by libsndfile ${libsndfile} \
        --subst-var-by mesa ${mesa} \
        --subst-var-by openal ${openal} \
        --subst-var-by zlib ${zlib} \

    substitute $dwarfFortressTemplate $out/bin/dwarf-fortress \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var prefix

    chmod 755 $out/bin/dwarf-fortress

    popd
  '' + stdenv.lib.optionalString dfHackEnabled ''

    originalSourceRoot=$sourceRoot
    export sourceRoot=$dfHackSourceRoot

    pushd ../../$sourceRoot/build

    mkdir -p $out/dfhack

    make install

    cp ../package/linux/dfhack $out/dfhack/

    mkdir -p $out/bin

    substitute $dfHackTemplate $out/bin/dfhack \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var prefix
    chmod 755 $out/bin/dfhack

    substitute $dfHackRunTemplate $out/bin/dfhack-run \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var prefix
    chmod 755 $out/bin/dfhack-run

    popd

    export sourceRoot=$originalSourceRoot
    unset originalSourceRoot
  '';

  fixupPhase = ''
    # Fix rpath
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc stdenv.glibc ]}:$out/share/df_linux/libs" $out/share/df_linux/libs/Dwarf_Fortress

    patchelf --set-interpreter ${glibc}/lib/ld-linux.so.2 $out/share/df_linux/libs/Dwarf_Fortress

    # Store new hash
    patched_hash=$(md5sum $out/share/df_linux/libs/Dwarf_Fortress | awk '{ print $1 }')
    echo $patched_hash | cut -c1-8 > $out/share/df_linux/hash.md5.patched  # for dwarf-therapist
    echo $patched_hash > $out/share/df_linux/full-hash-patched.md5  # for dfhack
  '' + stdenv.lib.optionalString dfHackEnabled ''
    find $out/share/df_linux/hack \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -print -exec patchelf --shrink-rpath {} \;

    sed -i "s/$(cat $out/share/df_linux/full-hash-orig.md5)/$(cat $out/share/df_linux/full-hash-patched.md5)/" $out/share/df_linux/hack/symbols.xml
  '';

  meta = {
    description = "A single-player fantasy game with a randomly generated adventure world";
    homepage = http://www.bay12games.com/dwarves;
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = with stdenv.lib.maintainers; [ a1russell robbinch roconnor the-kenny ];
  };
}
