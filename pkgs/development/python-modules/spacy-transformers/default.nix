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
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-+VIQXcffodzR6QEr2ZfvEIBGIxqKwsNZotI+Eh0EOIw=";
=======
    hash = "sha256-oNdH0oZNo8XWx+bbzwZs7iXD0Af6zx1k6wBYksgtp4w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
