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
  version = "4.68.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GYKclnNjjyoLhhfaTNy5J+gxzYi8/LbnjUKk0a8TFSA=";
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

  pytestFlags = [
    "-Wignore::FutureWarning"
    "-Wignore::DeprecationWarning"
  ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  disabledTests = [ "perf" ];

  env.LC_ALL = "en_US.UTF-8";

  pythonImportsCheck = [ "tqdm" ];

  meta = {
    description = "Fast, Extensible Progress Meter";
    mainProgram = "tqdm";
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://tqdm.github.io/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
}
