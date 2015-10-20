{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "1jxvjknz2jhq773jrwx9gc1df3gfy73yqmkjkygqxzpi318yls3q";
  };

  meta = {
    description = "Unit conversion tool";
    platforms = stdenv.lib.platforms.linux;
  };
}
