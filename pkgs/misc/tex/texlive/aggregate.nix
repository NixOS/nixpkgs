args : with args;
rec {
  phaseNames = ["doAggregate"];
  name = "TeXLive-linkdir";

  buildInputs = lib.closePropagation paths;

  doAggregate = FullDepEntry (''

    for currentPath in ${lib.concatStringsSep " " buildInputs}; do
        echo Symlinking "$currentPath"
        find $currentPath/share ! -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
	    ensureDir $out/"$(dirname "$REPLY")"
	    ln -fs $currentPath/"$REPLY" $out/"$REPLY"
	    echo
        done | while read; do head -n 99 >/dev/null; echo -n .; done
	echo

	cp -Trfp $currentPath/libexec $out/libexec || true
    done

    rm -r $out/share/texmf-config
    find $out/share/texmf -type d | while read; do
      REPLY="''${REPLY#$out/share/texmf}"
      ensureDir $out/share/texmf-config/"$REPLY"
    done

    ensureDir $out/bin
    for i in $out/libexec/*/*; do
        echo -ne "#! /bin/sh\\n$i \"\$@\"" >$out/bin/$(basename $i)
        chmod a+x $out/bin/$(basename $i)
    done

    rm $out/share/texmf*/ls-R
    for i in web2c texconfig fonts/map; do
        cp -r $out/share/texmf/$i/* $out/share/texmf-config/$i || true
    done

    TEXMFCONFIG=$out/share/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*
    TEXMFCONFIG=$out/share/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    PATH=$PATH:$out/bin mktexlsr $out/share/texmf*
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
