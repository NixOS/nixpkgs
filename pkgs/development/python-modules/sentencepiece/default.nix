{ buildPythonPackage
, stdenv
, sentencepiece
, pkgconfig
}:

buildPythonPackage rec {
  pname = "sentencepiece";
  inherit (sentencepiece) version src meta;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sentencepiece ];

  sourceRoot = "source/python";
}
