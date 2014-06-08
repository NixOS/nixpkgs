{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "redis-2.8.9";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "7834c37f2ff186c46aef8e4a066dfbf1d6772a285aa31c19c58162f264f1007f";
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
