a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "0.18" a; 
  buildInputs = with a; [
    zlib e2fsprogs acl 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/kernel/people/mason/btrfs/btrfs-progs-${version}.tar.bz2";
    sha256 = "032g9lyrinpnrx4b8hs5i6qfbmv8x4ss02p26fgvk4zbc0slh7z8";
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
