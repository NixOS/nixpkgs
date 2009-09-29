args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.7.0" args; 
  buildInputs = with args; [
    libpng libtiff libjpeg librsvg imagemagick pkgconfig
    zlib libX11 bzip2 libtool
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/libdmtx/libdmtx-${version}.tar.bz2";
    sha256 = "00w0pvpbwqqa1c8s85v8vf8w1x116yh7qg5fplxj5jhmfizcama2";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "dmtx-" + version;
  meta = {
    description = "DataMatrix (2D bar code) processing tools.";
    maintainers = [args.lib.maintainers.raskin];
    platforms = args.lib.platforms.linux;
  };
}
