args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.7.2" args; 
  buildInputs = with args; [
    libpng libtiff libjpeg librsvg imagemagick pkgconfig
    zlib libX11 bzip2 libtool freetype fontconfig 
    ghostscript jasper xz
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/libdmtx/libdmtx-${version}.tar.bz2";
    sha256 = "0iin2j3ad7ldj32dwc04g28k54iv3lrc5121rgyphm7l9hvigbvk";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "dmtx-" + version;
  meta = {
    description = "DataMatrix (2D bar code) processing tools";
    maintainers = [args.lib.maintainers.raskin];
    platforms = args.lib.platforms.linux;
  };
}
