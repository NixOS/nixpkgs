{ stdenv, fetchurl, flex, bison, readline }:

stdenv.mkDerivation rec {
  name = "bird-1.3.11";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "15c4d9cyd6l8jdlrvmzvwmpga81llm8zxqvbsir9gvwgzn6zbmna";
  };

  buildInputs = [ flex bison readline ];

  meta = {
    description = "";
    homepage = http://bird.network.cz;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
