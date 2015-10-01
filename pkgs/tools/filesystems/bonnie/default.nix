{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "bonnie++-1.03e";
  src = fetchurl {
    url = http://www.coker.com.au/bonnie++/bonnie++-1.03e.tgz;
    sha256 = "1jz2l8dz08c7vxvchigisv5a293yz95bw1k81dv6bgrlcq8ncf6b";
  };
  enableParallelBuilding = true;
  meta = {
    homepage = "http://www.coker.com.au/bonnie++/";
    description = "Hard drive and file system benchmark suite";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
