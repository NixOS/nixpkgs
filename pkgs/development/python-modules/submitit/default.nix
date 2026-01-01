{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cloudpickle,
  flit-core,
  typing-extensions,
  pytestCheckHook,
<<<<<<< HEAD
  pytest-asyncio,
=======
  pytest-asyncio_0,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "submitit";
<<<<<<< HEAD
  version = "1.5.4";
=======
  version = "1.5.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Q/2mC7viLYl8fx7dtQueZqT191EbERZPfN0WkTS/U1w=";
=======
    hash = "sha256-uBlKbg1oKeUPcWzM9WxisGtpBu69eZyTetaANYpTG5E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  dependencies = [
    cloudpickle
<<<<<<< HEAD
=======
    setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # event_loop was removed in pytest-asyncio 1.x
<<<<<<< HEAD
    pytest-asyncio
=======
    pytest-asyncio_0
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
