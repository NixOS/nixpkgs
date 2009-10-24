a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    libx86 pciutils zlib
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixPCIref" "doConfigure" "doMakeInstall"];

  fixPCIref = a.fullDepEntry (''
    sed -e 's@$(libdir)/libpci.a@${a.pciutils}/lib/libpci.so@' -i Makefile.in
    export NIX_LDFLAGS="$NIX_LDFLAGS -lpci"
  '') ["doUnpack" "minInit"];
      
  meta = {
    description = "Video BIOS execution tool";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
