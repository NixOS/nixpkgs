{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {
  name = "parcellite-1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/parcellite/${name}.tar.gz";
    sha256 = "0nz951ykj162mfbcn3w9zk525ww6qcqn5yqdx13nx70fnn6rappi";
  };

  buildInputs = [ pkgconfig intltool gtk2 ];

  meta = {
    description = "Lightweight GTK+ clipboard manager";
    homepage = "http://parcellite.sourceforge.net";
    license = "GPLv3+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
