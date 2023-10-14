{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, pythonRelaxDepsHook
, torch
, pythonOlder
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+VIQXcffodzR6QEr2ZfvEIBGIxqKwsNZotI+Eh0EOIw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    torch
    spacy
    spacy-alignments
    srsly
    transformers
  ];

  pythonRelaxDeps = [
    "transformers"
  ];

  # Test fails due to missing arguments for trfs2arrays().
  doCheck = false;

  pythonImportsCheck = [
    "spacy_transformers"
  ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    changelog = "https://github.com/explosion/spacy-transformers/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
