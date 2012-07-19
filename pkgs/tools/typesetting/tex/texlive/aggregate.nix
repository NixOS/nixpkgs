args : with args;
rec {
  phaseNames = ["doAggregate"];
  name = "TeXLive-linkdir";

  buildInputs = lib.closePropagation paths;

  doAggregate = fullDepEntry (''

    mkdir -p $out/bin
    for currentPath in ${lib.concatStringsSep " " buildInputs}; do
        echo Symlinking "$currentPath"
        find $currentPath/share/info $currentPath/share/man $(echo $currentPath/texmf*/) ! -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
            mkdir -p $out/"$(dirname "$REPLY")"
            ln -fs $currentPath/"$REPLY" $out/"$REPLY"
            echo
        done | while read; do head -n 99 >/dev/null; echo -n .; done

        for i in "$currentPath/bin/"* :; do
            test "$i" != : || continue
            echo -ne "#! $SHELL\\nexec $i \"\$@\"" > "$out/bin/$(basename "$i")" && \
            chmod a+x "$out/bin/$(basename "$i")"
        done

        echo

        cp -Trfp $currentPath/libexec $out/libexec || true
    done

    ln -s $out/texmf* $out/share/

    rm -r $out/texmf-config
    find $out/texmf/ -type d | while read; do
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

    rm $out/texmf*/ls-R
    for i in web2c texconfig fonts/map; do
        cp -Lr $out/texmf/$i/* $out/texmf-config/$i || true
    done
    chmod -R u+w $out/texmf-config

    yes | TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    yes | PATH=$PATH:$out/bin mktexlsr $out/texmf*
    yes | TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    yes | PATH=$PATH:$out/bin mktexlsr $out/texmf*
  '') ["minInit" "defEnsureDir" "addInputs"];

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
