{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cloudpickle,
  flit-core,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio_0,
}:

buildPythonPackage rec {
  pname = "submitit";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    tag = version;
    hash = "sha256-uBlKbg1oKeUPcWzM9WxisGtpBu69eZyTetaANYpTG5E=";
  };

  build-system = [ flit-core ];

  dependencies = [
    cloudpickle
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # event_loop was removed in pytest-asyncio 1.x
    pytest-asyncio_0
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
