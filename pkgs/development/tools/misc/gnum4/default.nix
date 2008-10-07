{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnum4-1.4.11";
  
  src = fetchurl {
    url = mirror://gnu/m4/m4-1.4.11.tar.bz2;
    sha256 = "1bcakymxddxykg5vbll3d9xq17m5sa3r6cprf1k27x5k4mjnhz0b";
  };

  meta = {
    homepage = http://www.gnu.org/software/m4/;
    description = "An implementation of the traditional Unix macro processor";
  };
}
