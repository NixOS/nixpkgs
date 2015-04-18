{stdenv, fetchurl, cups}:

stdenv.mkDerivation rec {
  name = "cups-bjnp-1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/cups-bjnp/${name}.tar.gz";
    sha256 = "0sb0vm1sf8ismzd9ba33qswxmsirj2z1b7lnyrc9v5ixm7q0bnrm";
  };

  preConfigure = ''configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"'';

  buildInputs = [cups];
  NIX_CFLAGS_COMPILE = "-include stdio.h";

  meta = {
    homepage = http://cups-bjnp.sourceforge.net;
  };
}
