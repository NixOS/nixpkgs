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
  version = "1.1.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G09bZiXTdEuukvKjPOYYTW/B19d406QSRDOU5ZflDDU=";
  };

  postPatch = ''
    sed -i 's/transformers>=3.4.0,<4.13.0/transformers/' setup.cfg
  '';

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
