args : with args;
rec {
  phaseNames = ["doAggregate"];
  name = "TeXLive-linkdir";

  buildInputs = lib.closePropagation paths;

  doAggregate = fullDepEntry (''

  ensureDir $out/libexec

    for currentPath in ${lib.concatStringsSep " " buildInputs}; do
        echo Symlinking "$currentPath"
        find $currentPath/share/info $currentPath/share/man $(echo $currentPath/texmf*) ! -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
	    ensureDir $out/"$(dirname "$REPLY")"
	    ln -fs $currentPath/"$REPLY" $out/"$REPLY"
	    echo
        done | while read; do head -n 99 >/dev/null; echo -n .; done
	echo

        find "$currentPath/libexec" -type d | while read; do
            REPLY="''${REPLY#$currentPath}"
	    ensureDir $out/"$REPLY"
	done
        find "$currentPath/libexec" -type f | while read; do
            REPLY="''${REPLY#$currentPath}"
	    ln -s "$currentPath"/"$REPLY" $out/"$REPLY"
	done
        find "$currentPath/libexec" -type l | while read; do
            REPLY="''${REPLY#$currentPath}"
	    ln -s "$currentPath"/"$REPLY" $out/"$REPLY"
	done
    done

    ln -s $out/texmf* $out/share/

    rm -r $out/texmf-config
    find $out/texmf/ -type d | while read; do
      REPLY="''${REPLY#$out/texmf}"
      ensureDir $out/texmf-config/"$REPLY"
    done

    ensureDir $out/bin
    for i in $out/libexec/*/*; do
        if [ -x $(readlink -f $i) ]; then
            echo -ne "#! /bin/sh\\n$i \"\$@\"" >$out/bin/$(basename $i)
            chmod a+x $out/bin/$(basename $i)
        fi;
    done

    rm $out/texmf*/ls-R
    for i in web2c texconfig fonts/map; do
        cp -r $out/texmf/$i/* $out/texmf-config/$i || true
    done

    TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    PATH=$PATH:$out/bin mktexlsr $out/texmf*
    TEXMFCONFIG=$out/texmf-config HOME=$PWD PATH=$PATH:$out/bin updmap --syncwithtrees
    PATH=$PATH:$out/bin mktexlsr $out/texmf*
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
