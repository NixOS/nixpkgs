{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "4.0.1";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "14bm8lkhylc93r4dgl7kkzzpw2xq7gr6w6h80n3jazqnx5mcsj90";
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
