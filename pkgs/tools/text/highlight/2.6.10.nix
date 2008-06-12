
args : with args; 
rec {
  src = fetchurl {
    url = http://www.andre-simon.de/zip/highlight-2.6.10.tar.bz2;
    sha256 = "18f2ki9pajxlp0aq4ingxj7m0cp7wlbc40xm25pnxc1yis9vlira";
  };

  buildInputs = [getopt];
  configureFlags = [];
  makeFlags = ["PREFIX=$out"];

  /* doConfigure should be specified separately */
  phaseNames = ["doMakeInstall"];
      
  name = "highlight-" + version;
  meta = {
    description = "Source code highlighting tool";
  };
}
