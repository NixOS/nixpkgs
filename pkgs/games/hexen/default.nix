{stdenv, fetchurl, SDL} :

stdenv.mkDerivation {
  name = "hexen-0.2.3";
  src = fetchurl {
    url = http://www.libsdl.org/projects/hexen/src/hexen-0.2.3.tar.gz;
    sha256 = "c1433e930f2003c5f817f935406bb28ba15298a15b1c11f83f42df3e9f1f3bc4";
  };

  buildInputs = [ SDL ];

  meta = {
    homepage = http://www.libsdl.org/projects/hexen/;
    description = "Port of Raven Software's popular Hexen 3-D shooter game";
    license = stdenv.lib.licenses.free;
    broken = true;
  };
}
