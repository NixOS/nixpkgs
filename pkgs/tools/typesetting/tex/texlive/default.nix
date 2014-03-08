args : with args;
rec {
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-bin/texlive-bin_2013.20130729.30972.orig.tar.xz;
    sha256 = "1idgyim6r4bi3id245k616qrdarfh65xv3gi2psarqqmsw504yhd";
  };

  texmfVersion = "2013.20140215";
  texmfSrc = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-base/texlive-base_${texmfVersion}.orig.tar.xz";
    sha256 = "0f1xqa1a1yklsiqz12rgihdc6viw8ghdbx2s2pw2k3h0dfsd6ss3";
  };

  langTexmfVersion = "2013.20140215";
  langTexmfSrc = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-lang/texlive-lang_${langTexmfVersion}.orig.tar.xz";
    sha256 = "0igz9kpd1rfbq7smb1wyd75cz396rinbh25rk19lxqh25dix0xzj";
  };

  passthru = { inherit texmfSrc langTexmfSrc; };

  setupHook = ./setup-hook.sh;

  doMainBuild = fullDepEntry ( stdenv.lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${poppler}/lib"
  '' + ''
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
    sed -e 's/-lttf/-lfreetype/' -i $(find . -name configure)

    sed -e s@ncurses/curses.h@curses.h@g -i $(grep ncurses/curses.h -rl . )
    sed -e '1i\#include <string.h>\n\#include <stdlib.h>' -i $( find libs/teckit -name '*.cpp' -o -name '*.c' )

    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/layout";

    ./Build --prefix="$out" --datadir="$out/share" --mandir="$out/share/man" --infodir="$out/share/info" \
      ${args.lib.concatStringsSep " " configureFlags}
    cd Work
  '' ) [ "minInit" "doUnpack" "addInputs" "defEnsureDir" ];

  promoteLibexec = fullDepEntry (''
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
  '') ["doMakeInstall"];

  doPostInstall = fullDepEntry( ''
    cp -r "$out/"texmf* "$out/share/" || true
    rm -rf "$out"/texmf*
    [ -d $out/share/texmf-config ] || ln -s $out/share/texmf-dist $out/share/texmf-config
    ln -s "$out"/share/texmf* "$out"/

    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*

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
    mkdir -p "$out/share/texmf-var/web2c"
    ln -sf "$out"/out/share/texmf* "$out"/
    PATH="$PATH:$out/bin" fmtutil-sys --all || true

    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${poppler}/lib"
    done
  '' ) [ "minInit" "defEnsureDir" "doUnpack" "doMakeInstall" "promoteLibexec" "patchShebangsInterim"];

  patchShebangsInterimBin = doPatchShebangs ''$out/bin/'';
  patchShebangsInterimLibexec = doPatchShebangs ''$out/libexec/'';
  patchShebangsInterimShareTexmfDist = doPatchShebangs ''$out/share/texmf-dist/scripts/'';
  patchShebangsInterimTexmfDist = doPatchShebangs ''$out/texmf-dist/scripts/'';

  patchShebangsInterim = fullDepEntry ("") ["patchShebangsInterimBin"
    "patchShebangsInterimLibexec" "patchShebangsInterimTexmfDist"
    "patchShebangsInterimShareTexmfDist"];

  buildInputs = [ zlib bzip2 ncurses libpng flex bison libX11 libICE xproto
    freetype t1lib gd libXaw icu ghostscript ed libXt libXpm libXmu libXext
    xextproto perl libSM ruby expat curl libjpeg python fontconfig xz pkgconfig
    poppler graphite2 lesstif zziplib harfbuzz texinfo ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper ];

  configureFlags = [ "--with-x11" "--enable-ipc" "--with-mktexfmt"
    "--enable-shared" "--disable-native-texlive-build" "--with-system-zziplib"
    "--with-system-libgs" "--with-system-t1lib" "--with-system-freetype2" 
    "--with-system-freetype=no" "--disable-ttf2pk" "--enable-ttf2pk2" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [
      # Complains about a missing ICU directory
      "--disable-bibtex-x"

      # TODO: We should be able to fix these tests
      "--disable-devnag"
      "--disable-dvisvgm"
      "--disable-xdv2pdf"
      "--disable-xdvipdfmx"
      "--disable-xetex"

      "--with-system-harfbuzz=no"
      "--with-system-icu=no"
    ];

  phaseNames = [ "addInputs" "doMainBuild" "doMakeInstall" "doPostInstall" ];

  name = "texlive-core-2013";

  meta = with stdenv.lib; {
    description = "A TeX distribution";
    homepage    = http://www.tug.org/texlive;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.unix;
  };
}
