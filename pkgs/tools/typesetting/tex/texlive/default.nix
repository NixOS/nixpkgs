args : with args;
rec {
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-bin/texlive-bin_2012.20120628.orig.tar.xz;
    sha256 = "0k94df3lfvghngzdzi2d4fz2z0gs8iglz7h3w2lxvlhiwwpmx601";
  };

  texmfSrc = fetchurl {
    url = mirror://debian/pool/main/t/texlive-base/texlive-base_2012.20120611.orig.tar.xz;
    sha256 = "116zm0qdq9rd4vakhd2py9q7lq3ihspc7hy33bh8wy5v1rgiqsm6";
  };

  langTexmfSrc = fetchurl {
    url = mirror://debian/pool/main/t/texlive-lang/texlive-lang_2012.20120611.orig.tar.xz;
    sha256 = "0zh9svszfkbjx72i7sa9gg0gak93wf05845mxpjv56h8qwk4bffv";
  };

  setupHook = ./setup-hook.sh;

  doMainBuild = fullDepEntry (''
    mkdir -p $out
    mkdir -p $out/nix-support
    cp ${setupHook} $out/nix-support/setup-hook.sh
    mkdir -p $out/share
    tar xf ${texmfSrc} -C $out --strip-components=1
    tar xf ${langTexmfSrc} -C $out --strip-components=1

    sed -e s@/usr/bin/@@g -i $(grep /usr/bin/ -rl . )

    sed -e 's@\<env ruby@${ruby}/bin/ruby@' -i $(grep 'env ruby' -rl . )
    sed -e 's@\<env perl@${perl}/bin/perl@' -i $(grep 'env perl' -rl . )
    sed -e 's@\<env python@${python}/bin/python@' -i $(grep 'env python' -rl . )

    sed -e '/ubidi_open/i#include <unicode/urename.h>' -i $(find . -name configure)
    sed -e s@ncurses/curses.h@curses.h@g -i $(grep ncurses/curses.h -rl . )
    sed -e '1i\#include <string.h>\n\#include <stdlib.h>' -i $( find libs/teckit -name '*.cpp' -o -name '*.c' )

    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/layout";

    ./Build --prefix="$out" --datadir="$out/share" --mandir "$out/share/man" --infodir "$out/share/info" \
      ${args.lib.concatStringsSep " " configureFlags}
    cd Work
  '') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];

  doPostInstall = fullDepEntry(''
    mkdir -p $out/libexec/
    mv $out/bin $out/libexec/$(uname -m)
    mkdir -p $out/bin
    for i in "$out/libexec/"* "$out/libexec/"*/* ; do
        test \( \! -d "$i" \) -a \( -x "$i" -o -L "$i" \) || continue
	if [ -x "$i" ]; then
	    echo -ne "#! $SHELL\\nexec $i \"\$@\"" >$out/bin/$(basename $i)
            chmod a+x $out/bin/$(basename $i)
	else
	    mv "$i" "$out/libexec"
	    ln -s "$(readlink -f "$out/libexec/$(basename "$i")")" "$out/bin/$(basename "$i")";
	    ln -sf "$(readlink -f "$out/libexec/$(basename "$i")")" "$out/libexec/$(uname -m)/$(basename "$i")";
            rm "$out/libexec/$(basename "$i")"
	fi;
    done
    [ -d $out/texmf-config ] || ln -s $out/texmf $out/texmf-config
    ln -s -v "$out/"*texmf* "$out/share/" || true

    sed -e 's/.*pyhyph.*/=&/' -i $out/texmf-config/tex/generic/config/language.dat

    PATH=$PATH:$out/bin mktexlsr $out/texmf*

    HOME=. PATH=$PATH:$out/bin updmap-sys --syncwithtrees

    # Prebuild the format files, as it used to be done with TeXLive 2007.
    # Luatex currently fails this way:
    #
    #   This is a summary of all `failed' messages:
    #   `luatex -ini  -jobname=luatex -progname=luatex luatex.ini' failed
    #   `luatex -ini  -jobname=dviluatex -progname=dviluatex dviluatex.ini' failed
    #
    # I find it acceptable, hence the "|| true".
    echo "building format files..."
    mkdir -p "$out/texmf-var/web2c"
    PATH="$PATH:$out/bin" fmtutil-sys --all || true

    PATH=$PATH:$out/bin mktexlsr $out/texmf*
 '') ["minInit" "defEnsureDir" "doUnpack" "doMakeInstall"];

  buildInputs = [
    zlib bzip2 ncurses libpng flex bison libX11 libICE
    xproto freetype t1lib gd libXaw icu ghostscript ed
    libXt libXpm libXmu libXext xextproto perl libSM
    ruby expat curl libjpeg python fontconfig xz
    pkgconfig poppler silgraphite lesstif zziplib
  ];

  configureFlags = [ "--with-x11"
    "--enable-ipc" "--with-mktexfmt" "--enable-shared"
    "--disable-native-texlive-build" "--with-system-zziplib"
    "--with-system-icu" "--with-system-libgs" "--with-system-t1lib"
    "--with-system-freetype2"
  ];

  phaseNames = ["addInputs" "doMainBuild" "doMakeInstall" "doPostInstall"];

  name = "texlive-core-2012";
  meta = {
    description = "A TeX distribution";
    maintainers = [ args.lib.maintainers.raskin ];
    platforms = args.lib.platforms.linux ++ args.lib.platforms.freebsd ;
  };
}
