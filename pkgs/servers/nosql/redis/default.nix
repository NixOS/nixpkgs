{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "4.0.9";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "0465bv6yxnwmas3wzg07vmrprv2pxhnr56hn5pxrybwf66y76kyz";
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
