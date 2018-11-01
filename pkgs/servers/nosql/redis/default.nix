{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "5.0.0";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "194rvj3wzdil2rny93vq9g9vlqnb7gv4vnwaklybgcj00qnqpjbh";
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
