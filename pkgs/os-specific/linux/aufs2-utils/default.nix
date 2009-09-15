a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
  ];
in
rec {
  src = (a.fetchGitFromSrcInfo s) + "/";

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  preBuild = a.fullDepEntry (''
    sed -e "s@/usr@@g; s@-o root@@g; s@-g root@@g" -i Makefile 
  '') ["doUnpack" "minInit"];
  postInstall = a.fullDepEntry (''
    sed -e "s@/etc/default@$out&@; s@/sbin/mount@$out&@" -i "$out/bin/"*
  '') ["minInit"];
  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "doMakeInstall" "postInstall"];
  makeFlags = [
    ''KDIR="${a.kernel}/lib/modules/${a.kernel.version}/build"''
    ''DESTDIR="$out"''
    ];
      
  meta = {
    description = "AUFS2 utilities";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
