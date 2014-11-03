{stdenv, fetchurl, libdnet, pkgconfig, libpcap}:

stdenv.mkDerivation {
  name = "hyenae-0.36-1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/hyenae/0.36-1/hyenae-0.36-1.tar.gz;
    sha256 = "1f3x4yn9a9p4f4wk4l8pv7hxfjc8q7cv20xzf7ky735sq1hj0xcg";
  };

  buildInputs = [libdnet pkgconfig libpcap];

  meta = {
    description = "";
    homepage = http://sourceforge.net/projects/hyenae/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
