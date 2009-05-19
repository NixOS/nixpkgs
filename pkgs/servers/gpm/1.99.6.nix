args : with args; 
rec {
  src = fetchurl {
    url = http://linux.schottelius.org/gpm/archives/gpm-1.99.6.tar.lzma;
    sha256 = "14zxx7nx40k8b0bmwhxfyv20xrdi8cg9fxmv8ylsx661lvizqsg3";
  };

  buildInputs = [lzma flex bison ncurses];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = fullDepEntry (''
    sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
    sed -e 's/gpm2//' -i Makefile.in
  '') ["addInputs" "doUnpack" "minInit"];
      
  name = "gpm-" + version;
  meta = {
    description = "Mouse daemon";
  };
}
