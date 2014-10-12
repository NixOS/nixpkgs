args: with args;
rec {
  version = "2014.05.21.20140528";
  name = "context_${version}";
  src = fetchurl {
    url = "mirror://debian/pool/main/c/context/${name}.orig.tar.gz";
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
 
