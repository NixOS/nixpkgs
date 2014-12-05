{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "redis-2.8.17";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "19rnwapbsvfhd9pwdjdshrpqimf1ms0pzakvgnjrywkijmiwrisk";
  };

  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = "BSD";
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
