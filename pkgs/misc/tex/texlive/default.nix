args : with args; 
rec {
  src = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-bin/texlive-bin_2007.orig.tar.gz;
    sha256 = "1fz5lqbigdrdg0pmaynissd7wn59p2yj9f203nl93dcpffrapxjv";
  };
  
  texmfSrc = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-base/texlive-base_2007.orig.tar.gz;
    sha256 = "16a4dyliidk43qj0m4gpsl9ln7nqsdcdx1lkbk4wrm03xpx87zvh";
  };

  langTexmfSrc = fetchurl {
    url = mirror://debian/pool/main/t/texlive-lang/texlive-lang_2007.orig.tar.gz;
    sha256 = "0cmd9ryd57rzzg7g2gm3qn4ijakkacy810h5zncqd39p3i1yn6nx";
  };

  setupHook = ./setup-hook.sh;

  doPreConfigure = FullDepEntry (''
    ensureDir $out
    ensureDir $out/nix-support 
    cp ${setupHook} $out/nix-support/setup-hook.sh
    ensureDir $out/share
    tar xf ${texmfSrc} -C $out/share --strip-components=1
    tar xf ${langTexmfSrc} -C $out/share --strip-components=1
    cp -r texmf* $out/share
    cd build/source
    sed -e s@/usr/bin/@@g -i $(grep /usr/bin/ -rl . )
    sed -e '/ubidi_open/i#include <unicode/urename.h>' -i $(find . -name configure)
    sed -e s@ncurses/curses.h@curses.h@g -i $(grep ncurses/curses.h -rl . ) 

    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/layout";
  '') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];

  doPostInstall = FullDepEntry(''
    mv $out/bin $out/libexec
    ensureDir $out/bin
    for i in $out/libexec/*/*; do
        echo -ne "#! /bin/sh\\n$i \"\$@\"" >$out/bin/$(basename $i)
        chmod a+x $out/bin/$(basename $i)
    done
    texmf_var=$(mktemp -d /var/tmp/texmf-varXXXXXXXX)
    mv $out/share/texmf-var/* $texmf_var/ 
    chmod -R a+rwX $texmf_var
    rm -r $out/share/texmf-var || true
    rm -r /var/tmp/texmf-var || true
    ln -sfT $texmf_var $out/share/texmf-var
    ln -sfT $texmf_var /var/tmp/texmf-var
    ln -s $out/share/texmf $out/share/texmf-config
    
    sed -e 's/.*pyhyph.*/=&/' -i $out/share/texmf-config/tex/generic/config/language.dat

    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*

    HOME=. PATH=$PATH:$out/bin updmap-sys --syncwithtrees
    
    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*
 '') ["minInit" "defEnsureDir" "doUnpack" "doMakeInstall"];

  buildInputs = [
    zlib bzip2 ncurses libpng flex bison libX11 libICE
    xproto freetype t1lib gd libXaw icu ghostscript ed 
    libXt libXpm libXmu libXext xextproto perl libSM 
  ];

  configureFlags = [ "--with-x11" "--with-system-zlib" 
    "--with-system-freetype2" "--with-system-t1lib" 
    "--with-system-pnglib" "--with-system-gd" 
    "--with-system-icu" "--with-system-ncurses" 
    "--enable-ipc" "--with-mktexfmt"
  ];

  phaseNames = ["doPreConfigure" "doConfigure" 
    "doMakeInstall" "doPostInstall"];

  name = "texlive-core-2007";
  meta = {
    description = "A TeX distribution";
    srcs = [texmfSrc langTexmfSrc];
  };
}
