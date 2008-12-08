a :  
let 
  fetchurl = a.fetchurl;
  
  version = a.lib.getAttr ["version"] "1.2" a; 
  buildInputs = with a; [
    gpm fontconfig freetype pkgconfig
  ];
in
rec {
  src = fetchurl {
    url = "http://fbterm.googlecode.com/files/fbterm-${version}.tar.gz";
    sha256 = "0q4axmnpwlpjlpaj19iw7nyxkqsvwq767szdkzsgancq99afwqyd";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "fbterm-" + version;
  meta = {
    description = "Framebuffer terminal emulator";
  };
}
