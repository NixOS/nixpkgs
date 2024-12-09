{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
  numpy,
  pandas,
  rich,
  tkinter,
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.66.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4QIK7y5QlnAtigJax9FrFXcnnJ1j+DdbYwg+ml8Py60=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    # tests of optional features
    numpy
    rich
    tkinter
    pandas
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::FutureWarning"
    "-W"
    "ignore::DeprecationWarning"
  ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  disabledTests = [ "perf" ];

  LC_ALL = "en_US.UTF-8";

  pythonImportsCheck = [ "tqdm" ];

  meta = with lib; {
    description = "Fast, Extensible Progress Meter";
    mainProgram = "tqdm";
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://tqdm.github.io/releases/";
    license = with licenses; [ mit ];
  };
}
