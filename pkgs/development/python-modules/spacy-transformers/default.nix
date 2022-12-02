{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, dataclasses
, torch
, pythonOlder
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e7YuBEq2yggW5G2pJ0Rjw9z3c1jqgRKCifYSfnzblVs=";
  };

  propagatedBuildInputs = [
    torch
    spacy
    spacy-alignments
    srsly
    transformers
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
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
