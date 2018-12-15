{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "zdelta-2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "0k6y0r9kv5qiglnr2j4a0yvfynjkvm0pyv8ly28j0pr3w6rbxrh3";
  };

  meta = with stdenv.lib; {
	  homepage = http://cis.poly.edu/zdelta;
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
