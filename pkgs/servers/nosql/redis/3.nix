{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.0.0-rc2";
  name = "redis-${version}";

  src = fetchurl {
    url = "https://github.com/antirez/redis/archive/${version}.tar.gz";
    sha256 = "3713194850e1b75fa01f17249a69e67636c1ad3f148fd15950d08d7a87bcf463";
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
