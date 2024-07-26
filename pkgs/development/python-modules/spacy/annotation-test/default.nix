{ stdenv, pytest, spacy_models }:

stdenv.mkDerivation {
  name = "spacy-annotation-test";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  nativeCheckInputs = [ pytest spacy_models.en_core_web_sm ];

  checkPhase = ''
    pytest annotate.py
  '';

  installPhase = ''
    touch $out
  '';

  meta.timeout = 60;
}
