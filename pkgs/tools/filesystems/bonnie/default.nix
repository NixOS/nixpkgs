{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bonnie++-1.97.3";
  src = fetchurl {
    url = "http://www.coker.com.au/bonnie++/experimental/${name}.tgz";
    sha256 = "0vkl42rsrsy95fc1ykc6g8rsdbnpxayvdaihnnkly1fww1m3hyz2";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.coker.com.au/bonnie++/;
    description = "Hard drive and file system benchmark suite";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
