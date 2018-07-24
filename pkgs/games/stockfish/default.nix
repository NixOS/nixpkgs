{ stdenv, fetchurl }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";
in

stdenv.mkDerivation rec {

  name = "stockfish-9";

  src = fetchurl {
    url = "https://github.com/official-stockfish/Stockfish/archive/sf_9.tar.gz";
    sha256 = "1i37izc3sq9vr663iaxpfh008lgsw7abzj1ws5l1hf3b6xjkgwyh";
  };

  postUnpack = "sourceRoot+=/src";
  makeFlags = [ "PREFIX=$(out)" "ARCH=${arch}" ];
  buildFlags = "build ";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://stockfishchess.org/;
    description = "Strong open source chess engine";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro peti ];
    platforms = ["x86_64-linux" "i686-linux"];
    license = licenses.gpl2;
  };

}
