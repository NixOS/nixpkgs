{
  lib,
  stdenv,
  pytest,
  spacy-models,
}:

stdenv.mkDerivation {
  name = "spacy-transformers-annotation-test";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./annotate.py
    ];
  };

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  nativeCheckInputs = [
    pytest
    spacy-models.en_core_web_trf
  ];

  checkPhase = ''
    pytest annotate.py
  '';

  installPhase = ''
    touch $out
  '';

  meta.timeout = 60;
}
