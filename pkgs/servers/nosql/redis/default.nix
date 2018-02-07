{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "4.0.7";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "1lgcc5k6bg7f34lxbfx0xv74nj66khd5x8g1igyy2h7v8inm9fhv";
  };

  buildInputs = [ lua ];
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
