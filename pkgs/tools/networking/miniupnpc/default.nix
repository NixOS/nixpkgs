{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniupnpc-${version}";
  version = "2.0.20161216";

  src = fetchurl {
    url = "http://miniupnp.free.fr/files/download.php?file=${name}.tar.gz";
    sha256 = "0gpxva9jkjvqwawff5y51r6bmsmdhixl3i5bmzlqsqpwsq449q81";
   };

   patches = stdenv.lib.optional stdenv.isFreeBSD ./freebsd.patch;

   doCheck = !stdenv.isFreeBSD;

  installFlags = "PREFIX=$(out) INSTALLPREFIX=$(out)";

  meta = {
    homepage = http://miniupnp.free.fr/;
    description = "A client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with stdenv.lib.platforms; linux ++ freebsd;
  };
}
