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
    ensureDir $out/share/texmf
    cp -r * $out/share/texmf
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "ConTEXt TeX wrapper";
  };

}
 
