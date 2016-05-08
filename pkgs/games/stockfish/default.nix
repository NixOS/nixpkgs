{ stdenv, fetchurl, unzip }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";
in

stdenv.mkDerivation rec {

  name = "stockfish-7";

  src = fetchurl {
    url = "https://stockfish.s3.amazonaws.com/${name}-src.zip";
    sha256 = "0djzg3h5d9qs27snf0rr6zl6iaki1jb84v8m8k3c2lcjbj2vpwc9";
  };

  buildInputs = [ unzip ];
  postUnpack = "sourceRoot+=/src";
  makeFlags = [ "PREFIX=$out" "ARCH=${arch}" ];
  buildFlags = "build";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro peti ];
    platforms = with platforms; i686 ++ x86_64;
    license = licenses.gpl2;
  };

}
