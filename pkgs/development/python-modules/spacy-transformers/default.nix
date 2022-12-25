{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, torch
, pythonOlder
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2uU6y/rsvNSLpeXL6O9IOQ0RMN0AEMH+/IKH6uufusU=";
  };

  propagatedBuildInputs = [
    torch
    spacy
    spacy-alignments
    srsly
    transformers
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "transformers>=3.4.0,<4.22.0" "transformers>=3.4.0 # ,<4.22.0"
  '';

  # Test fails due to missing arguments for trfs2arrays().
  doCheck = false;

  pythonImportsCheck = [
    "spacy_transformers"
  ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
