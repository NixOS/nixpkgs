a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    fuse bison flex
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
    ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Distributed storage system";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux ++ freebsd;
  };
}
