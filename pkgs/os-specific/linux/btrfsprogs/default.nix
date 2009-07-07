a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.19" a; 
  buildInputs = with a; [
    zlib e2fsprogs acl 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/kernel/people/mason/btrfs/btrfs-progs-${version}.tar.bz2";
    sha256 = "1z3hmfgv7h489gnh55abm0gzyf2cgjkybhfc2rnm0cvsx01xv8zq";
  };

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall"];
      
  name = "btrfs-progs-" + version;
  meta = {
    description = "BTRFS utilities";
  };
}
