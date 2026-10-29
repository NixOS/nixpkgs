{
  buildPythonPackage,

  sentencepiece,
  pkg-config,
}:

buildPythonPackage (finalAttrs: {
  pname = "sentencepiece";
  format = "setuptools";
  inherit (sentencepiece) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sentencepiece.dev ];

  sourceRoot = "${finalAttrs.src.name}/python";

  pythonImportsCheck = [ "sentencepiece" ];

  # sentencepiece installs 'bin' output.
  meta = removeAttrs sentencepiece.meta [ "outputsToInstall" ];
})
