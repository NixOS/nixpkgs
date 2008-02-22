args : with args; with builderDefs {src="";} null;
  let localDefs = builderDefs (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = http://www.netfilter.org/projects/iptables/files/iptables-1.4.0.tar.bz2;
      sha256 = "0ljxbvdlg5mfxk0y00dr0qvsri1d495ci1pr8hrzga766n09g6px";
    };

    buildInputs = [];
    configureFlags = [];
    makeFlags = [
      " KERNEL_DIR=${kernelHeaders} "
    ];
    preBuild = FullDepEntry (''
      sed -e 's@/usr/local@'$out'@' -i Makefile Rules.make
    '') ["doUnpack" "minInit"];
  }) null; /* null is a terminator for sumArgs */
  in with localDefs;
stdenv.mkDerivation rec {
  name = "iptables-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [preBuild doMakeInstall doForceShare doPropagate]);
  meta = {
    description = "
     IPtables Linux firewall.
";
  };
}
