{stdenv, fetchurl, cups}:

stdenv.mkDerivation rec {
  name = "cups-bjnp-1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/cups-bjnp/${name}.tar.gz";
    sha256 = "0fjpp0mmmwfcr790hfjs0brsxxb7dz7v2xab6wc30rwzkqmgz95x";
  };

  preConfigure = ''configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"'';

  buildInputs = [cups];
  NIX_CFLAGS_COMPILE = "-include stdio.h";

  meta = {
    homepage = http://cups-bjnp.sourceforge.net;
  };
}
