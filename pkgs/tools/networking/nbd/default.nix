{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation rec {
  name = "nbd-2.9.13";
  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "map arbitrary files as block devices over the network";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.bz2";
    sha256 = "d83da56a97ae70c6c52c994a64e960eaae0664fcadf1fc30f4c9f68c00d19da1";
  };
  buildInputs = [pkgconfig glib];

  # Desirable, but doesn't work because glib is compiled without static
  # libraries by default:
  #
  # configureFlags = "LDFLAGS=-static";
}
