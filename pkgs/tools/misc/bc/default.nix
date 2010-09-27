{stdenv, fetchurl, flex, readline}:

stdenv.mkDerivation {
  name = "bc-1.0.6";
  src = fetchurl {
    url = mirror://gnu/bc/bc-1.06.tar.gz;
    md5 = "d44b5dddebd8a7a7309aea6c36fda117";
  };

  patches = [ ./readlinefix.patch ];

  configureFlags = "--with-readline";

  buildInputs = [flex readline];

  meta = {
    description = "GNU software calculator";
    homepage = http://www.gnu.org/software/bc/;
  };
}
