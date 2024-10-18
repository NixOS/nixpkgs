{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cloudpickle,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "submitit";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    rev = "refs/tags/${version}";
    hash = "sha256-N54qbj4aI5R4cbMxyQ84hkPUgZMSYGeWzDws50/X+bA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "submitit"
  ];

  disabledTests = [
    "test_snapshot"
    "test_snapshot_excludes"
    "test_job_use_snapshot_cwd"
    "test_job_use_snapshot_modules"
    "test_nested_pickling"
  ];

  meta = {
    changelog = "https://github.com/facebookincubator/submitit/releases/tag/${version}";
    description = "Python 3.8+ toolbox for submitting jobs to Slurm";
    homepage = "https://github.com/facebookincubator/submitit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
