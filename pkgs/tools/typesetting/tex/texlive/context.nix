args @ { texLive, ... }: with args;
rec {
  name = "context-2014.05.21";
  src = fetchurl {
    url = mirror://debian/pool/main/c/context/context_2014.05.21.20140528.orig.tar.gz;
    sha256 = "1d744xrsjyl52x2xbh87k5ad826mzz8yqmhdznrmqrhk3qpjkzic";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share/

    mkdir -p $out/texmf-dist
    cp -r * $out/texmf-dist

    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "ConTEXt TeX wrapper";
  };

}

