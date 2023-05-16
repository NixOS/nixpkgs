{ buildPythonPackage

, sentencepiece
, pkg-config
}:

buildPythonPackage rec {
  pname = "sentencepiece";
  inherit (sentencepiece) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sentencepiece.dev ];

<<<<<<< HEAD
  sourceRoot = "${src.name}/python";
=======
  sourceRoot = "source/python";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # sentencepiece installs 'bin' output.
  meta = builtins.removeAttrs sentencepiece.meta [ "outputsToInstall" ];
}
