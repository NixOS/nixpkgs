{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "bchunk";
  version = "1.2.2";

  src = fetchurl {
    url = "http://he.fi/bchunk/${pname}-${version}.tar.gz";
    sha256 = "12dxx98kbpc5z4dgni25280088bhlsb677rp832r82zzc1drpng7";
  };

  makeFlags = lib.optionals stdenv.cc.isClang [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    install -Dt $out/bin bchunk
    install -Dt $out/share/man/man1 bchunk.1
  '';

  meta = with lib; {
    homepage = "http://he.fi/bchunk/";
    description = "A program that converts CD images in BIN/CUE format into a set of ISO and CDR tracks";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "bchunk";
  };
}
