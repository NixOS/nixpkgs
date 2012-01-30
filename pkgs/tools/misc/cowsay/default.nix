{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "cowsay-3.03";
  src = fetchurl {
    url = http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz;
    sha256 = "1bxj802na2si2bk5zh7n0b7c33mg8a5n2wnvh0vihl9bmjkp51hb";
  };
  buildInputs = [perl];
  installPhase = ''
    bash ./install.sh $out
  '';
}
