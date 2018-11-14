{ fetchurl, stdenv, libpng, autoreconfHook }:

# debian splits this package into plotutils and libplot2c2

# gentoo passes X, this package contains fonts
# I'm only interested in making pstoedit convert to svg

stdenv.mkDerivation rec {
  name = "plotutils-2.6";

  src = fetchurl {
    url = "mirror://gnu/plotutils/${name}.tar.gz";
    sha256 = "1arkyizn5wbgvbh53aziv3s6lmd3wm9lqzkhxb3hijlp1y124hjg";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpng ];
  patches = map fetchurl (import ./debian-patches.nix);

  preBuild = ''
    # Fix parallel building.
    make -C libplot xmi.h
  '';

  configureFlags = [ "--enable-libplotter" ]; # required for pstoedit

  hardeningDisable = [ "format" ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Powerful C/C++ library for exporting 2D vector graphics";

    longDescription =
      '' The GNU plotutils package contains software for both programmers and
         technical users.  Its centerpiece is libplot, a powerful C/C++
         function library for exporting 2-D vector graphics in many file
         formats, both vector and raster.  It can also do vector graphics
         animations.

         libplot is device-independent in the sense that its API (application
         programming interface) does not depend on the type of graphics file
         to be exported.

         Besides libplot, the package contains command-line programs for
         plotting scientific data.  Many of them use libplot to export
         graphics.
      '';

    homepage = http://www.gnu.org/software/plotutils/;

    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.unix;
  };
}
