args : with args; 
rec {
  src = fetchurl {
    url = http://linux.schottelius.org/gpm/archives/releases-2008/gpm-1.20.3pre6.tar.lzma;
    sha256 = "0sps9987w7daxfkbavzyi694n7ggf1wd5lh81nwka87m90q7rah7";
  };

  buildInputs = [lzma flex bison ncurses];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = FullDepEntry (''
    sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
  '') ["addInputs" "doUnpack" "minInit"];
      
  name = "gpm-" + version;
  meta = {
    description = "Mouse daemon";
  };
}
