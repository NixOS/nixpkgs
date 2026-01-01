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

<<<<<<< HEAD
  pythonImportsCheck = [ "sentencepiece" ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # sentencepiece installs 'bin' output.
  meta = removeAttrs sentencepiece.meta [ "outputsToInstall" ];
}
