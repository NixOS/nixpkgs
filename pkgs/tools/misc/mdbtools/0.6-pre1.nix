args : with args; 
rec {
  src = fetchurl {
    url = http://prdownloads.sourceforge.net/mdbtools/mdbtools-0.6pre1.tar.gz;
    sha256 = "1lz33lmqifjszad7rl1r7rpxbziprrm5rkb27wmswyl5v98dqsbi";
  };

  buildInputs = [glib readline bison flex pkgconfig];
  configureFlags = [];

  preConfigure = FullDepEntry (''
    sed -e 's@static \(GHashTable [*]mdb_backends;\)@\1@' -i src/libmdb/backend.c
  '') ["doUnpack" "minInit"];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];
      
  name = "mdbtools-" + version;
  meta = {
    description = ".mdb (MS Access) format tools";
  };
}
