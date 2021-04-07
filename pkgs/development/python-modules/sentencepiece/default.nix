{ buildPythonPackage

, sentencepiece
, pkg-config
}:

buildPythonPackage rec {
  pname = "sentencepiece";
  inherit (sentencepiece) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sentencepiece.dev ];

  sourceRoot = "source/python";

  # sentencepiece installs 'bin' output.
  meta = builtins.removeAttrs sentencepiece.meta [ "outputsToInstall" ];
}
