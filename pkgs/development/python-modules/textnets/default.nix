{ lib
, buildPythonPackage
, cairocffi
, cython
, fetchPypi
, igraph
, leidenalg
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
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
  version = "0.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fx2S43IqpSMsfJow26jB/D27dyUFQ1PlXP1rbUIZPPQ=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
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

  meta = with lib; {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
