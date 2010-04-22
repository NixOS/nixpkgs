{stdenv, fetchurl, cups}:

stdenv.mkDerivation rec {
  name = "cups-bjnp-0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/cups-bjnp/${name}.tar.gz";
    sha256 = "1q5npis0jgs44yvczrr6pz87glk1d9lv3vr2s4nqrk3l0q4xplf6";
  };

  preConfigure = ''configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"'';

  buildInputs = [cups];

  meta = {
    homepage = http://cups-bjnp.sourceforge.net;
  };
}
