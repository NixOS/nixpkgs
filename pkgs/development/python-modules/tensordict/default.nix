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
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    rev = "refs/tags/v${version}";
    hash = "sha256-XTFUzPs/fqX3DPtu/qSE1hY+7r/HToPVPaTyVRzDT/E=";
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
