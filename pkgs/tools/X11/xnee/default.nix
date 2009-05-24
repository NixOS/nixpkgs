args :  
let 
  fetchurl = args.fetchurl;
  lib=args.lib;

  version = lib.attrByPath ["version"] "3.01" args; 
  buildInputs = with args; [
    libX11 xproto libXext xextproto libXtst gtk
    libXi inputproto pkgconfig recordproto 
  ];
in
rec {
  src = fetchurl {
    url = "mirror://gnu/xnee/Xnee-${version}.tar.gz";
    sha256 = "1g6wq1hjrmx102gg768nfs8a1ck77g5fn4pmprpsz9123xl4d181";
  };

  inherit buildInputs;
  configureFlags = [
    "--disable-gnome-applet"
  ];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "xnee-" + version;
  meta = {
    description = "X event recording and replay tool.";
  };
}

