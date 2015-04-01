{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "redis-2.8.19";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "29bb08abfc3d392b2f0c3e7f48ec46dd09ab1023f9a5575fc2a93546f4ca5145";
  };

  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
