{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation rec {
  name = "nbd-2.9.15";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "26e2ef18cc2f214d666eef1cfb31df1ba8ee6eaa78390afd6d18f2cce9c0c704";
  };

  buildInputs = [pkgconfig glib];

  # Link this package statically to generate an nbd-server binary that
  # has no dynamic dependencies and that can be used on (non-Nix) remote
  # machines that have a different setup than the local one.
  configureFlags = "LDFLAGS=-static";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.simons  ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
