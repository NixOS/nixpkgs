{ lib, stdenv, fetchurl, cmake, protobuf, libiconv }:

stdenv.mkDerivation rec {
  pname = "jumanpp";
  version = "2.0.0-rc3";

  src = fetchurl {
    url = "https://github.com/ku-nlp/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ASdr6qbkSe71M7QmuuwidCa4xQhDVoXBJ2XqvSY53pQ=";
  };

  patches = [ ./0001-Exclude-all-tests-from-the-build.patch ];
  cmakeFlags = [ "-DJPP_ENABLE_TESTS=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ]
    ++ lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A Japanese morphological analyser using a recurrent neural network language model (RNNLM)";
    longDescription = ''
      JUMAN++ is a new morphological analyser that considers semantic
      plausibility of word sequences by using a recurrent neural network
      language model (RNNLM).
    '';
    homepage = "https://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN++";
    license = licenses.asl20;
    maintainers = with maintainers; [ mt-caret ];
    platforms = platforms.all;
  };
}
