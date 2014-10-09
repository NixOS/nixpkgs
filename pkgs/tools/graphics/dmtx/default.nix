args :
let
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.7.4" args;
  buildInputs = with args; [
    libpng libtiff libjpeg librsvg imagemagick pkgconfig
    zlib libX11 bzip2 libtool freetype fontconfig
    ghostscript jasper xz
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/libdmtx/libdmtx-${version}.tar.bz2";
    sha256 = "0xnxx075ycy58n92yfda2z9zgd41h3d4ik5d9l197lzsqim5hb5n";
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
