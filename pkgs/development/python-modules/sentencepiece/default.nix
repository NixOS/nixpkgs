{ buildPythonPackage
, stdenv
, sentencepiece
, pkgconfig
}:

buildPythonPackage rec {
  pname = "sentencepiece";
  inherit (sentencepiece) version src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sentencepiece.dev ];

  sourceRoot = "source/python";

  # sentencepiece installs 'bin' output.
  meta = builtins.removeAttrs sentencepiece.meta [ "outputsToInstall" ];
}
