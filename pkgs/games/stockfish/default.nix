{ stdenv, fetchurl, unzip }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";
in

stdenv.mkDerivation rec {

  name = "stockfish-8";

  src = fetchurl {
    url = "https://stockfish.s3.amazonaws.com/${name}-src.zip";
    sha256 = "1sachz41kbni88yjxwv5y4vl0gjbnyqvp1kpdm7v56k43zr3dbbv";
  };

  buildInputs = [ unzip ];
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
