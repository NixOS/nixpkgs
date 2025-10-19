{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cloudpickle,
  flit-core,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "submitit";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    tag = version;
    hash = "sha256-PDQLzqQjoBAZM9FKsoRby26Pbh4nik3SltIHUw/xWcY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
    flit-core
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "submitit"
  ];

  disabledTests = [
    # These tests are broken
    "test_snapshot"
    "test_snapshot_excludes"
    "test_job_use_snapshot_cwd"
    "test_job_use_snapshot_modules"
    "test_nested_pickling"
    "test_setup"
    "test_requeuing"
  ];

  meta = {
    changelog = "https://github.com/facebookincubator/submitit/releases/tag/${version}";
    description = "Python 3.8+ toolbox for submitting jobs to Slurm";
    homepage = "https://github.com/facebookincubator/submitit";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
