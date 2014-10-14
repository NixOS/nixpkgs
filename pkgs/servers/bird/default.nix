{ stdenv, fetchurl, flex, bison, readline }:

stdenv.mkDerivation rec {
  name = "bird-1.4.4";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "0dh14zi3v1j0iwxxcyfymfdyaxxmilfbf3bc4mwj682jb3x6ll7g";
  };

  buildInputs = [ flex bison readline ];

  meta = {
    description = "";
    homepage = http://bird.network.cz;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
