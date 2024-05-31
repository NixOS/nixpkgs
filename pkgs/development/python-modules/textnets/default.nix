{
  lib,
  buildPythonPackage,
  cairocffi,
  cython,
  fetchPypi,
  igraph,
  leidenalg,
  pandas,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  scipy,
  setuptools,
  spacy,
  spacy-lookups-data,
  en_core_web_sm,
  toolz,
  tqdm,
  wasabi,
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

  nativeBuildInputs = [
    pythonRelaxDepsHook
    cython
    poetry-core
    setuptools
  ];

  pythonRelaxDeps = [
    "igraph"
    "leidenalg"
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
