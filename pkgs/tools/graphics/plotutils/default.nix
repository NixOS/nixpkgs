{
  fetchurl,
  lib,
  stdenv,
  libpng,
  autoreconfHook,
}:

# debian splits this package into plotutils and libplot2c2

# gentoo passes X, this package contains fonts
# I'm only interested in making pstoedit convert to svg

stdenv.mkDerivation rec {
  pname = "plotutils";
  version = "2.6";

  src = fetchurl {
    url = "mirror://gnu/plotutils/plotutils-${version}.tar.gz";
    sha256 = "1arkyizn5wbgvbh53aziv3s6lmd3wm9lqzkhxb3hijlp1y124hjg";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpng ];
  patches =
    map fetchurl (import ./debian-patches.nix)
    # `pic2plot/gram.cc` uses the register storage class specifier, which is not supported in C++17.
    # This prevents clang 16 from building plotutils because it defaults to C++17.
    ++ [ ./c++17-register-usage-fix.patch ];

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

    longDescription = ''
      The GNU plotutils package contains software for both programmers and
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

    homepage = "https://www.gnu.org/software/plotutils/";

    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
