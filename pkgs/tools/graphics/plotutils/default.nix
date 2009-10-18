args: with args;

# debian splits this package into plotutils and libplot2c2

# gentoo passes X, this package contains fonts
# I'm only interested in making pstoedit convert to svg

let name = "plotutils-2.6";
in

stdenv.mkDerivation {

  inherit name;

  src = fetchurl {
    url = "http://mirrors.zerg.biz/gnu/plotutils/${name}.tar.gz";
    sha256 = "1arkyizn5wbgvbh53aziv3s6lmd3wm9lqzkhxb3hijlp1y124hjg";
  };

  buildInputs = [libpng];

  configureFlags = "--enable-libplotter"; # required for pstoedit

  meta = { 
    description = "a powerful C/C++ function library for exporting 2-D vector graphics";
    homepage = http://www.gnu.org/software/plotutils/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
