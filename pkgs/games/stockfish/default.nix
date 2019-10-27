{ stdenv, fetchurl }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";

    version = "10";
in

stdenv.mkDerivation {

  pname = "stockfish";
  inherit version;

  src = fetchurl {
    url = "https://github.com/official-stockfish/Stockfish/archive/sf_${version}.tar.gz";
    sha256 = "1lrxqq8fw1wrw5b45r4s3ddd51yr85a2k8a9i1wjvyd6v9vm7761";
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
