args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/jfsrec/jfsrec-svn-7.tar.gz;
    sha256 = "163z6ljr05vw2k5mj4fim2nlg4khjyibrii95370pvn474mg28vg";
  };

  buildInputs = [boost];
  configureFlags = [];

  doFixBoost = FullDepEntry (''
    sed -e 's/-lboost_[a-z_]*/&-mt/g' -i src/Makefile.in
  '') ["minInit" "doUnpack"];

  /* doConfigure should be specified separately */
  phaseNames = ["doFixBoost" "doConfigure" "doMakeInstall"];
      
  name = "jfsrec-" + version;
  meta = {
    description = "JFS recovery tool";
  };
}
