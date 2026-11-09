{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
  dask,
  numpy,
  pandas,
  rich,
  tkinter,
}:

buildPythonPackage (finalAttrs: {
  pname = "tqdm";
  version = "4.70.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tqdm";
    repo = "tqdm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2p4FcTmc+CfUNRm8Ox53dTHbKelmOCfut4XKCtze+Bo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    # tests of optional features
    dask
    numpy
    rich
    tkinter
    pandas
  ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  disabledTests = [ "perf" ];

  pythonImportsCheck = [ "tqdm" ];

  meta = {
    description = "Fast, Extensible Progress Meter";
    mainProgram = "tqdm";
    homepage = "https://github.com/tqdm/tqdm";
    changelog = "https://tqdm.github.io/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
