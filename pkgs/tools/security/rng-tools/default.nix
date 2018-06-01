{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rng-tools-5";

  src = fetchurl {
    url = "mirror://sourceforge/gkernel/${name}.tar.gz";

    sha256 = "13h7lc8wl9khhvkr0i3bl5j9bapf8anhqis1lcnwxg1vc2v058b0";
  };

  # For cross-compilation
  makeFlags = [ "AR:=$(AR)" ];

  meta = {
    description = "A random number generator daemon";

    homepage = https://sourceforge.net/projects/gkernel;

    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
