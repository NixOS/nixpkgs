{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, pytorch
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AYshH2trMTgeSkAPRb6wRWpm4gA5FaKV2NJd+PhzAy4=";
  };

  propagatedBuildInputs = [
    pytorch
    spacy
    spacy-alignments
    srsly
    transformers
  ];

  # Test fails due to missing arguments for trfs2arrays().
  doCheck = false;

  pythonImportsCheck = [ "spacy_transformers" ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
