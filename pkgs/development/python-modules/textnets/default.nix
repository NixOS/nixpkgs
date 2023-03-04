{ lib
, buildPythonPackage
, cairocffi
, cython
, fetchFromGitHub
, igraph
, leidenalg
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, scipy
, setuptools
, spacy
, en_core_web_sm
, toolz
, tqdm
, wasabi
}:

buildPythonPackage rec {
  pname = "textnets";
  version = "0.8.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jboynyc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BBndY+3leJBxiImuyRL7gMD5eocE4i96+97I9hDEwec=";
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
    toolz
    tqdm
    wasabi
  ];

  # Deselect test of experimental feature that fails due to having an
  # additional dependency.
  disabledTests = [
    "test_context"
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
