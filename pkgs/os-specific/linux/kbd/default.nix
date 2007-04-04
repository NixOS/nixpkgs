{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "kbd-1.12";

  src = fetchurl {
    url = ftp://ftp.win.tue.nl/pub/linux-local/utils/kbd/kbd-1.12.tar.gz;
    sha256 = "00z89kscfhvbsd3pxkqiw95p124zcka0pji5s5fa7ld7vd3ngg7k";
  };

  buildInputs = [bison flex];

  makeFlags = "setowner= ";
}
