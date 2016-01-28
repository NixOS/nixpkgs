args @ {poppler, perl, makeWrapper, ... }: with args;
rec {
  name = "TeXLive-linkdir";

  buildInputs = lib.closePropagation paths
    ++ [perl]
    ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  phaseNames = [ "doAggregate" ];

  doAggregate = fullDepEntry (''
    set +o pipefail

    mkdir -p $out/bin
    for currentPath in ${lib.concatStringsSep " " buildInputs}; do
        echo Symlinking "$currentPath"
        find $currentPath/share/info $currentPath/share/man $(echo $currentPath/texmf*/) -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
            mkdir -p $out/"$REPLY"
        done
        find $currentPath/share/info $currentPath/share/man $(echo $currentPath/texmf*/) ! -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
            ln -fs $currentPath/"$REPLY" $out/"$REPLY"
            echo
        done | while read; do head -n 999 >/dev/null; echo -n .; done

        for i in "$currentPath/bin/"* :; do
            test "$i" != : || continue
            echo -ne "#! $SHELL\\nexec $i \"\$@\"" > "$out/bin/$(basename "$i")" && \
            chmod a+x "$out/bin/$(basename "$i")"
        done

        echo

        cp -Trfp $currentPath/libexec $out/libexec || true
    done

    ln -s $out/texmf* $out/share/

    rm -rf $out/texmf-config
    find $out/texmf*/ -type d | while read; do
      REPLY="''${REPLY#$out/texmf}"
      mkdir -p $out/texmf-config/"$REPLY"
    done

    for i in $out/libexec/*/* :; do
        test "$i" = : && continue;
        test -f "$i" && \
        test -x "$i" && \
        echo -ne "#! $SHELL\\nexec $i \"\$@\"" >$out/bin/$(basename $i) && \
        chmod a+x $out/bin/$(basename $i)
    done

    rm -f $out/texmf*/ls-R
    for i in web2c texconfig fonts/map; do
        mkdir -p $out/texmf-config/$i
        cp -Lr $out/texmf*/$i/* $out/texmf-config/$i || true
    done
    chmod -R u+w $out/texmf-config

    yes | TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    yes | PATH=$PATH:$out/bin mktexlsr $out/texmf*
    yes | TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    yes | PATH=$PATH:$out/bin mktexlsr $out/texmf*
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # did the same thing in texLive, but couldn't get it to carry to the
    # binaries installed by texLiveFull
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${poppler.out}/lib"
    done
  '' ) [ "minInit" "defEnsureDir" "addInputs" ];

  preferLocalBuild = true;

  meta = {
    description = "TeX distribution directory";
    longDescription = ''
      Here all the files from different TeX-related
      packages are collected in one directory. Of
      course, mktexlsr is called. Later placed
      directories take precedence. It is supposed that
      share and libexec are symlinked, and bin is
      recreated with wrappers for libexec-located
      linked binaries.
    '';
  };
}
