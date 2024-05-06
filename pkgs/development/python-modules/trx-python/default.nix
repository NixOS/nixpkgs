{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  setuptools-scm,
  deepdiff,
  nibabel,
  numpy,
  pytestCheckHook,
  psutil,
}:

buildPythonPackage rec {
  pname = "trx-python";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tee-ar-ex";
    repo = "trx-python";
    rev = "refs/tags/${version}";
    hash = "sha256-gKPgP3GJ7QY0Piylk5L0HxnscRCREP1Hm5HZufL2h5g=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  dependencies = [
    deepdiff
    nibabel
    numpy
  ];

  pythonImportsCheck = [ "trx" ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [ "trx/tests" ];

  disabledTestPaths = [
    # access to network
    "trx/tests/test_memmap.py"
    "trx/tests/test_io.py"
  ];

  meta = {
    description = "Python implementation of the TRX file format";
    homepage = "https://github.com/tee-ar-ex/trx-python";
    changelog = "https://github.com/tee-ar-ex/trx-python/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
