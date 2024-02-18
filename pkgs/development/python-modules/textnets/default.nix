{ lib
, buildPythonPackage
, cairocffi
, cython_3
, fetchPypi
, igraph
, leidenalg
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, scipy
, setuptools
, spacy
, spacy-lookups-data
, en_core_web_sm
, toolz
, tqdm
, wasabi
}:

buildPythonPackage rec {
  pname = "textnets";
  version = "0.9.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4154ytzo1QpwhKA1BkVMss9fNIkysnClW/yfSVlX33M=";
  };

  pythonRelaxDeps = [
    "igraph"
  ];

  nativeBuildInputs = [
    cython_3
    poetry-core
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    cairocffi
    igraph
    leidenalg
    pandas
    scipy
    spacy
    spacy-lookups-data
    toolz
    tqdm
    wasabi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    en_core_web_sm
  ];

  pythonImportsCheck = [
    "textnets"
  ];

  disabledTests = [
    # Test fails: A warning is triggered because of a deprecation notice by pandas.
    # TODO: Try to re-enable it when pandas is updated to 2.1.1
    "test_corpus_czech"
  ];

  meta = with lib; {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
