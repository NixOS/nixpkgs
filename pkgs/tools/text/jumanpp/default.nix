{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  protobuf,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "jumanpp";
  version = "2.0.0-rc3";

  src = fetchurl {
    url = "https://github.com/ku-nlp/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ASdr6qbkSe71M7QmuuwidCa4xQhDVoXBJ2XqvSY53pQ=";
  };

  patches = [
    ./0001-Exclude-all-tests-from-the-build.patch
    # https://github.com/ku-nlp/jumanpp/pull/132
    (fetchpatch {
      name = "fix-unused-warning.patch";
      url = "https://github.com/ku-nlp/jumanpp/commit/cc0d555287c8b214e9d6f0279c449a4e035deee4.patch";
      sha256 = "sha256-yRKwuUJ2UPXJcjxBGhSOmcQI/EOijiJDMmmmSRdNpX8=";
    })
    (fetchpatch {
      name = "update-libs.patch";
      url = "https://github.com/ku-nlp/jumanpp/commit/5e9068f56ae310ed7c1df185b14d49654ffe1ab6.patch";
      sha256 = "sha256-X49/ZoLT0OGePLZYlgacNxA1dHM4WYdQ8I4LW3sW16E=";
    })
    (fetchpatch {
      name = "fix-mmap-on-apple-m1.patch";
      url = "https://github.com/ku-nlp/jumanpp/commit/0c22249f12928d0c962f03f229026661bf0c7921.patch";
      sha256 = "sha256-g6CuruqyoMJxU/hlNoALx1QnFM8BlTsTd0pwlVrco3I=";
    })
  ];
  cmakeFlags = [ "-DJPP_ENABLE_TESTS=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ] ++ lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A Japanese morphological analyser using a recurrent neural network language model (RNNLM)";
    mainProgram = "jumanpp";
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
