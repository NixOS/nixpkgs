{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "units-${version}";
  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/units/${name}.tar.gz";
    sha256 = "1jxvjknz2jhq773jrwx9gc1df3gfy73yqmkjkygqxzpi318yls3q";
  };

  buildInputs = [ readline ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Unit conversion tool";
    homepage = https://www.gnu.org/software/units/;
    license = [ licenses.gpl3Plus ];
    platforms = stdenv.lib.platforms.all;
  };
}
