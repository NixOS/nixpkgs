{ stdenv, fetchurl }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";

    version = "11";
in

stdenv.mkDerivation {

  pname = "stockfish";
  inherit version;

  src = fetchurl {
    url = "https://github.com/official-stockfish/Stockfish/archive/sf_${version}.tar.gz";
    sha256 = "16di83s79gf9kzdhcal5y0q9d59544gd5xqf1k8bwrqvc36628l0";
  };

  postUnpack = "sourceRoot+=/src";
  makeFlags = [ "PREFIX=$(out)" "ARCH=${arch}" ];
  buildFlags = [ "build" ];

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
