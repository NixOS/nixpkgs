{stdenv, fetchurl, zlib, libX11, libpng}:

stdenv.mkDerivation {
  name = "ploticus-2.41";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/ploticus/ploticus/2.41/pl241src.tar.gz;
    sha256 = "ecccb6afcf0008d5b31da2e9e74c448564101eb7b9bbde758a3dca1f2dc8c580";
  };

  buildInputs = [zlib libX11 libpng];

  patches = [./ploticus-install.patch];

  meta = {
    description = "A non-interactive software package for producing plots and charts";

    longDescription = ''Ploticus is a free, GPL'd, non-interactive
      software package for producing plots, charts, and graphics from
      data.  Ploticus is good for automated or just-in-time graph
      generation, handles date and time data nicely, and has basic
      statistical capabilities.  It allows significant user control
      over colors, styles, options and details.'';

    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://ploticus.sourceforge.net/;
  };
}
