{
  buildPythonPackage,

  sentencepiece,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "sentencepiece";
  format = "setuptools";
  inherit (sentencepiece) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sentencepiece.dev ];

  sourceRoot = "${src.name}/python";

  # sentencepiece installs 'bin' output.
  meta = builtins.removeAttrs sentencepiece.meta [ "outputsToInstall" ];
}
