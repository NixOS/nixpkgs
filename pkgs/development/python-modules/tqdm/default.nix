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
  version = "4.66.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Nk2yd6HJ5KPO+YHlZDpfZq/6NOaWQvmeOtZGf/Bhrs=";
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
