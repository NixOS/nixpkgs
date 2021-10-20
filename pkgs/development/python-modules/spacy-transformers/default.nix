{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, pytorch
, pythonOlder
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.1.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f66c4b08c3afe2c9f01bc4a377af3c62ea9c1aa7b67ff51f62b9be73d6609e49";
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
