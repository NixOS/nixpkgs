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

  fixInc = a.fullDepEntry (''
    sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
  '') ["doUnpack" "minInit"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixInc" "doConfigure" "doMakeInstall"];
      
  name = "fbterm-" + version;
  meta = {
    description = "Framebuffer terminal emulator";
  };
}
