a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.19" a; 
  buildInputs = with a; [
    zlib libuuid acl 
  ];
in

assert a.libuuid != null;

rec {
  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/kernel/people/mason/btrfs/btrfs-progs-${version}.tar.bz2";
    sha256 = "1z3hmfgv7h489gnh55abm0gzyf2cgjkybhfc2rnm0cvsx01xv8zq";
  };

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out"];

  patches = [ ./glibc212.patch ];
  phaseNames = ["doPatch" "doEnsureBtrfsImage" "doMakeInstall"];
      
  doEnsureBtrfsImage = a.fullDepEntry (''
    if ! grep 'progs = ' Makefile | grep btrfs-image; then 
      sed -e 's/progs = .*/& btrfs-image/' -i Makefile
    fi
  '') ["minInit" "doUnpack"];

  name = "btrfs-progs-" + version;
  meta = {
    description = "BTRFS utilities";
    maintainers = [a.lib.maintainers.raskin];
  };
}
