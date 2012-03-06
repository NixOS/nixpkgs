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
    mkdir -p $out/share/

    mkdir -p $out/texmf
    cp -r * $out/texmf

    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "ConTEXt TeX wrapper";
  };

}
 
