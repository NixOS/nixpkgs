{ stdenv, fetchurl, flex, bison, readline }:

stdenv.mkDerivation rec {
  name = "bird-1.4.5";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "1z4z7zmx3054zxi4q6a7095s267mw8ky628gir2n5xy5ch65yj7z";
  };

  buildInputs = [ flex bison readline ];

  meta = {
    description = "BIRD Internet Routing Daemon";
    homepage = http://bird.network.cz;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms  = stdenv.lib.platforms.linux;
  };
}
