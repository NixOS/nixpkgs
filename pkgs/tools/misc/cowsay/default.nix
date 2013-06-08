{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "cowsay-3.03";

  src = fetchurl {
    url = http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz;
    sha256 = "1s3c0g5vmsadicc4lrlkmkm8znm4y6wnxd8kyv9xgm676hban1il";
  };

  buildInputs = [ perl ];

  installPhase = ''
    bash ./install.sh $out
  '';

  meta = {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = http://www.nog.net/~tony/warez/cowsay.shtml;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
