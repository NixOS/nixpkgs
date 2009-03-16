args : with args; 
rec {
  src = fetchurl {
    url = http://linux.schottelius.org/gpm/archives/gpm-1.20.6.tar.lzma;
    sha256 = "13w61bh9nyjaa0n5a7qq1rvbqxjbxpqz5qmdmqqpqgrd2jlviar7";
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
