{
  lib,
  buildPythonPackage,
  cairocffi,
  cython,
  en_core_web_sm,
  fetchFromGitHub,
  igraph,
  leidenalg,
  pandas,
  poetry-core,
  pyarrow,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
  spacy-lookups-data,
  spacy,
  toolz,
  tqdm,
  wasabi,
}:

buildPythonPackage rec {
  pname = "textnets";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jboynyc";
    repo = "textnets";
    tag = "v${version}";
    hash = "sha256-MdKPxIshSx6U2EFGDTUS4EhoByyuVf0HKqvm9cS2KNY=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  pythonRelaxDeps = [
    "igraph"
    "leidenalg"
    "pyarrow"
    "toolz"
  ];

  dependencies = [
    cairocffi
    igraph
    leidenalg
    pandas
    pyarrow
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

  pythonImportsCheck = [ "textnets" ];

  # Enables the package to find the cythonized .so files during testing. See #255262
  preCheck = ''
    rm -r textnets
  '';

  disabledTests = [
    # Test fails: Throws a UserWarning asking the user to install `textnets[fca]`.
    "test_context"
  ];

  meta = with lib; {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
