{ stdenv, fetchurl, flex, bison, readline }:

stdenv.mkDerivation rec {
  name = "bird-1.4.0";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "1ickqvzpnyycq4a0l4d0kvf25pvq2vjayc0whqfv1233nb5426ys";
  };

  buildInputs = [ flex bison readline ];

  meta = {
    description = "";
    homepage = http://bird.network.cz;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
