{ stdenv, fetchurl, cmake, protobuf }:
stdenv.mkDerivation rec {
  pname = "jumanpp";
  name = "${pname}-${version}";
  version = "2.0.0-rc2";

  src = fetchurl {
    url = "https://github.com/ku-nlp/${pname}/releases/download/v${version}/${name}.tar.xz";
    sha256 = "17fzmd0f5m9ayfhsr0mg7hjp3pg1mhbgknhgyd8v87x46g8bg6qp";
  };
  buildInputs = [ cmake protobuf ];

  meta = with stdenv.lib; {
    description = "A Japanese morphological analyser using a recurrent neural network language model (RNNLM)";
    longDescription = ''
      JUMAN++ is a new morphological analyser that considers semantic
      plausibility of word sequences by using a recurrent neural network
      language model (RNNLM).
    '';
    homepage = http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN++;
    license = licenses.asl20;
    maintainers = with maintainers; [ mt-caret ];
    platforms = platforms.all;
  };
}
