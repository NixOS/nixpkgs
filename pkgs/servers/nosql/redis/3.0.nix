{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.0.1";
  name = "redis-${version}";

  src = fetchurl {
    url = "https://github.com/antirez/redis/archive/${version}.tar.gz";
    sha256 = "1m34s60qvj1xyqw7x7ar0graw52wypx47dhvfb0br67vfb62l8sl";
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
