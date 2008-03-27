args : with args; 
rec {
  src = fetchurl {
    url = http://jfs.sourceforge.net/project/pub/jfsutils-1.1.12.tar.gz;
    sha256 = "04vqdlg90j0mk5jkxpfg9fp6ss4gs1g5pappgns6183q3i6j02hd";
  };

  buildInputs = [e2fsprogs];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "jfsutils-" + version;
  meta = {
    description = "IBM JFS utilities";
  };
}
