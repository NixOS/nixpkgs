args: with args;
stdenv.mkDerivation {
  name = "cups-bjnp";

  src = fetchurl {
    url = mirror://sourceforge/project/cups-bjnp/cups-bjnp/0.5.4/cups-bjnp-0.5.4.tar.gz;
    sha256 = "1q5npis0jgs44yvczrr6pz87glk1d9lv3vr2s4nqrk3l0q4xplf6";
  };

  preConfigure = ''configureFlags="--with-cupsbackenddir=$out/lib/cups/backend"'';

  buildInputs = [cups];

  meta = { };
}
