{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "4.0.11";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "1fqvxlpaxr80iykyvpf1fia8rxh4zz8paf5nnjncsssqwwxfflzw";
  };

  buildInputs = [ lua ];
  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  doCheck = false; # needs tcl

  meta = with stdenv.lib; {
    homepage = https://redis.io;
    description = "An open source, advanced key-value store";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}
