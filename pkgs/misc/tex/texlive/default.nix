args : with args; 
rec {
  src = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-bin/texlive-bin_2007.dfsg.2.orig.tar.gz;
    sha256 = "0gqdz3sxpr6ibmasn847fg7q4m5rs4a370vld57kyl5djfrk33mq";
  };
  
  texmfSrc = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-base/texlive-base_2007.dfsg.2.orig.tar.gz;
    sha256 = "0qmwcz7d09ksrq26x4bqy5v3xjc4w2qkzfc1h6y9hs0gds6n8lnq";
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
    sed -e '1i\#include <string.h>\n\#include <stdlib.h>' -i $( find libs/teckit -name '*.cpp' -o -name '*.c' )

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
    ln -s $out/share/texmf $out/share/texmf-config
    
    sed -e 's/.*pyhyph.*/=&/' -i $out/share/texmf-config/tex/generic/config/language.dat
    sed -e 's@^#!env ruby@#! ${ruby}/bin/ruby@' -i $out/libexec/*/*
    sed -e 's@^#!env perl@#! ${perl}/bin/perl@' -i $out/libexec/*/*

    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*

    HOME=. PATH=$PATH:$out/bin updmap-sys --syncwithtrees
    
    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*
 '') ["minInit" "defEnsureDir" "doUnpack" "doMakeInstall"];

  buildInputs = [
    zlib bzip2 ncurses libpng flex bison libX11 libICE
    xproto freetype t1lib gd libXaw icu ghostscript ed 
    libXt libXpm libXmu libXext xextproto perl libSM 
    ruby expat curl libjpeg
  ];

  configureFlags = [ "--with-x11" "--with-system-zlib" 
    "--with-system-freetype2" "--with-system-t1lib" 
    "--with-system-pnglib" "--with-system-gd" 
    "--with-system-icu" "--with-system-ncurses" 
    "--enable-ipc" "--with-mktexfmt"
  ];

  phaseNames = ["addInputs" (doDump "0") "doPreConfigure" "doConfigure" 
    (doDump "1")
    "doMakeInstall" "doPostInstall"];

  name = "texlive-core-2007";
  meta = {
    description = "A TeX distribution";
    srcs = [texmfSrc langTexmfSrc];
  };
}

