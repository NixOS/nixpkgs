{ lib, stdenv, fetchurl, gtk2, pkg-config }:

stdenv.mkDerivation rec {
  version = "0.2.8-6";
  pname = "xarchive";

  src = fetchurl {
    url = "mirror://sourceforge/xarchive/${pname}-${version}.tar.gz";
    sha256 = "0chfim7z27s00naf43a61zsngwhvim14mg1p3csbv5i3f6m50xx4";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "GTK front-end for command line archiving tools";
    maintainers = [ lib.maintainers.domenkozar ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "xarchive";
  };
}
