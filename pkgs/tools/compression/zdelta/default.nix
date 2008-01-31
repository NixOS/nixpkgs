{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "zdelta-2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    md5 = "c69583a64f42f69a39e297d0d27d77e5";
  };

  meta = {
	  homepage = http://cis.poly.edu/zdelta;
  };
}
