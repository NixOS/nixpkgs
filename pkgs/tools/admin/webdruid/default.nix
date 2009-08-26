a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    zlib libpng freetype gd which libxml2
    geoip
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall" "doLinks"];
      
  doLinks = a.fullDepEntry (''
    ln -s shared_en.xsl $out/share/webdruid/classic/shared.xsl
  '') ["minInit"];

  meta = {
    description = "A web log analyzer";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = a.lib.platforms.linux;
  };
}
