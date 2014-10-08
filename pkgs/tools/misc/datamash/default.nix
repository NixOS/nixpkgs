{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "datamash-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/datamash/${name}.tar.gz";
    sha256 = "0154c25c45b5506b6d618ca8e18d0ef093dac47946ac0df464fb21e77b504118";
  };

  meta = {
    description = "GNU datamash";
    homepage = http://www.gnu.org/software/datamash/;
    platforms = stdenv.lib.platforms.all;
  };

}
