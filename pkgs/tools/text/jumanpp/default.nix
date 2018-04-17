{ stdenv, fetchurl, boost, libunwind, gperftools }:
stdenv.mkDerivation rec {
  name = "jumanpp";
  version = "1.02";
  src = fetchurl {
    url = "http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-${version}.tar.xz";
    sha256 = "14768b419bak8h2px8chw4cbfscb0jj012bpr769qv5nn6f53yh1";
  };
  buildInputs = [ boost libunwind gperftools ];
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
