{ stdenv, fetchurl, which, tcl }:

stdenv.mkDerivation rec {
  name = "redis-2.6.9";

  src = fetchurl {
    url = "http://redis.googlecode.com/files/${name}.tar.gz";
    sha256 = "12bl3inq7xr2lqlqbxjxa3v9s5v7xn2pxlbm72ivxbiq43zpx5jd";
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
