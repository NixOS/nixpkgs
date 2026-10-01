{
  lib,
  stdenv,
  pytest,
  spacy-models,
}:

stdenv.mkDerivation {
  name = "spacy-annotation-test";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./annotate.py
    ];
  };

  dontConfigure = true;
  dontBuild = true;

  nativeCheckInputs = [
    pytest
    spacy-models.en_core_web_sm
  ];

  checkPhase = ''
    pytest annotate.py
  '';

  installPhase = ''
    touch $out
  '';

  meta.timeout = 60;
}
