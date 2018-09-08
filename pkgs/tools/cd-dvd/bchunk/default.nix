{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bchunk-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "http://he.fi/bchunk/${name}.tar.gz";
    sha256 = "12dxx98kbpc5z4dgni25280088bhlsb677rp832r82zzc1drpng7";
  };

  makeFlags = stdenv.lib.optionals stdenv.cc.isClang [ "CC=cc" "LD=cc" ];

  installPhase = ''
    install -Dt $out/bin bchunk
    install -Dt $out/share/man/man1 bchunk.1
  '';

  meta = with stdenv.lib; {
    homepage = http://he.fi/bchunk/;
    description = "A program that converts CD images in BIN/CUE format into a set of ISO and CDR tracks";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
