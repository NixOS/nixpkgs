{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.0.0-rc3";
  name = "redis-${version}";

  src = fetchurl {
    url = "https://github.com/antirez/redis/archive/${version}.tar.gz";
    sha256 = "1695fa532eafc14c95f45add5d8a71d07e0e87b5c8f06c29dfa06313322d27b7";
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
