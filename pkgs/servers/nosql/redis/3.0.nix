{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.0.2";
  name = "redis-${version}";

  src = fetchurl {
    url = "https://github.com/antirez/redis/archive/${version}.tar.gz";
    sha256 = "00gazq98ccz64l4l5vzpynyk5wg15iwmwwvznaarkwm99b9rsz4g";
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
