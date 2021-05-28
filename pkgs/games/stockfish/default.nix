{ stdenv, fetchurl }:

let arch = if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";

    version = "12";

    nnueFile = "nn-82215d0fd0df.nnue";
    nnue = fetchurl {
      name = nnueFile;
        url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
      sha256 = "1r4yqrh4di05syyhl84hqcz84djpbd605b27zhbxwg6zs07ms8c2";
    };
in

stdenv.mkDerivation {
  pname = "stockfish";
  inherit version;

  src = fetchurl {
    url = "https://github.com/official-stockfish/Stockfish/archive/sf_${version}.tar.gz";
    sha256 = "16980aicm5i6i9252239q4f9bcxg1gnqkv6nphrmpz4drg8i3v6i";
  };

  postUnpack = ''
    sourceRoot+=/src
    echo ${nnue}
    cp "${nnue}" "$sourceRoot/${nnueFile}"
  '';

  makeFlags = [ "PREFIX=$(out)" "ARCH=${arch}" ];
  buildFlags = [ "build" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://stockfishchess.org/";
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
