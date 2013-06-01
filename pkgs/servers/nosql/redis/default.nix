{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "redis-2.6.13";

  src = fetchurl {
    url = "http://redis.googlecode.com/files/${name}.tar.gz";
    sha256 = "0j79a5vmdy0c1df89ymqk37kz8q2iqlzg81qwnz0djjqdiikk51v";
  };

  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = "BSD";
    platforms = stdenv.lib.platforms.unix;
  };
}
