{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "5.0.1";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "1jxbjmsxn0lgh0y3k5j57rxf2sdjj71hxhw4jcvsvycpxh77r9l2";
  };

  buildInputs = [ lua ];
  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  doCheck = false; # needs tcl

  meta = with stdenv.lib; {
    homepage = https://redis.io;
    description = "An open source, advanced key-value store";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
