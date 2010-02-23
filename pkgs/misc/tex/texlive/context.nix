args: with args;
rec {
  name = "context-2009.11.26";
  src = fetchurl {
    url = mirror://debian/pool/main/c/context/context_2009.11.26.orig.tar.gz;
    sha256 = "1qv3h97cyhjyvivs30fz9bqr77j348azagm7ijiyfrclvjjlwav9";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    ensureDir $out/share/

    ensureDir $out/texmf
    cp -r * $out/texmf

    ln -s $out/texmf* $out/share/

    sysName=$(ls -d ${args.texLive}/libexec/*/ | head -1)
    sysName=''${sysName%%/}
    sysName=''${sysName##*/}

    ensureDir $out/libexec/$sysName
    for i in $out/texmf/scripts/*/*/*; do
      ln -s $i $out/libexec/$sysName/$(basename $i)
    done
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  

  meta = {
    description = "ConTEXt TeX wrapper";
  };

}
 
