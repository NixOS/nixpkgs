{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  greenlet,
  trio,
  outcome,
  sniffio,
  pytest-trio,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.15.0";
  pyproject = true;

  # https://github.com/python-trio/trio-asyncio/issues/160
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "trio-asyncio";
    tag = "v${version}";
    hash = "sha256-6c+4sGEpCVC8wxBg+dYgkOwRAUOi/DTITrDx3M2koyE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    greenlet
    trio
    outcome
    sniffio
  ];

  pytestFlags = [
    # RuntimeWarning: Can't run the Python asyncio tests because they're not installed
    "-Wignore::RuntimeWarning"
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # TypeError: RaisesGroup.__init__() got an unexpected keyword argument 'strict'
    # https://github.com/python-trio/trio-asyncio/issues/154
    "test_run_trio_task_errors"
    "test_cancel_loop_with_tasks"
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trio_asyncio" ];

  meta = {
    changelog = "https://github.com/python-trio/trio-asyncio/blob/v${version}/docs/source/history.rst";
    description = "Re-implementation of the asyncio mainloop on top of Trio";
    homepage = "https://github.com/python-trio/trio-asyncio";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
