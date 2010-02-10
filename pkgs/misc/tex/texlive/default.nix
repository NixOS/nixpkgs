args : with args; 
rec {
  src = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-bin/texlive-bin_2009.orig.tar.gz;
    sha256 = "0ywc8h4jnig53fs0bji2ivw5f9j6zlgdy477jqw7xvpc7migjpw7";
  };
  
  texmfSrc = fetchurl { 
    url = mirror://debian/pool/main/t/texlive-base/texlive-base_2009.orig.tar.gz;
    sha256 = "130z907xcxr10yrzbbmp9l8a00dabvi4bi702s5jxamjzav17cmf";
  };

  langTexmfSrc = fetchurl {
    url = mirror://debian/pool/main/t/texlive-lang/texlive-lang_2009.orig.tar.gz;
    sha256 = "10shnsc71n95zy9ys938pljdid9ampmc50k4lji9wv53hm14laic";
  };

  setupHook = ./setup-hook.sh;

  doMainBuild = fullDepEntry (''
    ensureDir $out
    ensureDir $out/nix-support 
    cp ${setupHook} $out/nix-support/setup-hook.sh
    ensureDir $out/share
    tar xf ${texmfSrc} -C $out/share --strip-components=1
    tar xf ${langTexmfSrc} -C $out/share --strip-components=1

    sed -e s@/usr/bin/g@@ -i $(grep /usr/bin/ -rl . )

    sed -e 's@^#! ?env ruby@#! ${ruby}/bin/ruby@' -i $(grep 'env ruby' -rl . )
    sed -e 's@^#! ?env perl@#! ${perl}/bin/perl@' -i $(grep 'env perl' -rl . )
    sed -e 's@^#! ?env python@#! ${python}/bin/perl@' -i $(grep 'env python' -rl . )

    sed -e '/ubidi_open/i#include <unicode/urename.h>' -i $(find . -name configure)
    sed -e s@ncurses/curses.h@curses.h@g -i $(grep ncurses/curses.h -rl . ) 
    sed -e '1i\#include <string.h>\n\#include <stdlib.h>' -i $( find libs/teckit -name '*.cpp' -o -name '*.c' )

    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/layout";

    ./Build
  '') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];

  doPostInstall = fullDepEntry(''
    mv $out/bin $out/libexec
    ensureDir $out/bin
    for i in $out/libexec/*/*; do
        echo -ne "#! /bin/sh\\n$i \"\$@\"" >$out/bin/$(basename $i)
        chmod a+x $out/bin/$(basename $i)
    done
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
    ruby expat curl libjpeg python
  ];

  configureFlags = [ "--with-x11" 
    "--enable-ipc" "--with-mktexfmt"
  ];

  phaseNames = ["addInputs" (doDump "0") "doMainBuild" 
    (doDump "1")
    "doMakeInstall" "doPostInstall"];

  name = "texlive-core-2009";
  meta = {
    description = "A TeX distribution";
    maintainers = [ args.lib.maintainers.raskin ];
    platforms = args.lib.platforms.linux ++ args.lib.platforms.freebsd ;
  };
}

