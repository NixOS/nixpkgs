{stdenv, fetchurl, zlib, libX11, libpng}:

stdenv.mkDerivation {
  name = "ploticus-2.40";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/ploticus/pl240src.tar.gz;
    sha256 = "1gwppsmfxajrpidjrplkhvq2yy35r9hmigpwjmjqv4r7dj7cnrw8";
  };

  buildInputs = [zlib libX11 libpng];

  patches = [./ploticus-install.patch];

  meta = {
    description = ''Ploticus, a non-interactive software package for
                    producing plots and charts'';

    longDescription = ''Ploticus is a free, GPL'd, non-interactive
      software package for producing plots, charts, and graphics from
      data.  Ploticus is good for automated or just-in-time graph
      generation, handles date and time data nicely, and has basic
      statistical capabilities.  It allows significant user control
      over colors, styles, options and details.'';

    license = "GPL";
    homepage = http://ploticus.sourceforge.net/;
  };
}
