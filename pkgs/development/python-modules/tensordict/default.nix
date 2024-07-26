{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, torch
, wheel
, which
, cloudpickle
, numpy
, h5py
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "tensordict";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    rev = "refs/tags/v${version}";
    hash = "sha256-eCx1r7goqOdGX/0mSGCiLhdGQTh4Swa5aFiLSsL56p0=";
  };

  nativeBuildInputs = [
    setuptools
    torch
    wheel
    which
  ];

  propagatedBuildInputs = [
    cloudpickle
    numpy
    torch
  ];

  pythonImportsCheck = [
    "tensordict"
  ];

  # We have to delete the source because otherwise it is used instead of the installed package.
  preCheck = ''
    rm -rf tensordict
  '';

  nativeCheckInputs = [
    h5py
    pytestCheckHook
  ];

  # RuntimeError: internal error
  disabledTests = lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
    "test_add_scale_sequence"
    "test_modules"
    "test_setattr"
  ];

  # ModuleNotFoundError: No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "test/test_distributed.py"
  ];

  meta = with lib; {
    description = "A pytorch dedicated tensor container";
    changelog = "https://github.com/pytorch/tensordict/releases/tag/v${version}";
    homepage = "https://github.com/pytorch/tensordict";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
