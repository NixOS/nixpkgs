{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "bonnie++-1.97";
  src = fetchurl {
    url = http://www.coker.com.au/bonnie++/experimental/bonnie++-1.97.tgz;
    sha256 = "10jrqgvacvblyqv38pg5jb9jspyisxaladcrp8k6b2k46xcs1xa4";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./bonnie-homebrew.patch;

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.coker.com.au/bonnie++/";
    description = "Hard drive and file system benchmark suite";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
