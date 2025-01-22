{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  packaging,

  # tests
  awkward,
  dask-awkward,
  notebook,
  numba,
  papermill,
  pytestCheckHook,
  sympy,
}:

buildPythonPackage rec {
  pname = "vector";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "vector";
    tag = "v${version}";
    hash = "sha256-W10j1oQdmJ7GE0dCsAPtIsEPy4L2CIvVEZZqm7aHxII=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    packaging
  ];

  nativeCheckInputs = [
    awkward
    dask-awkward
    notebook
    numba
    papermill
    pytestCheckHook
    sympy
  ];

  pythonImportsCheck = [ "vector" ];

  __darwinAllowLocalNetworking = true;

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: assert 2.1073424255447017e-08 == 0.0
    "test_issue_463"
  ];

  meta = {
    description = "Library for 2D, 3D, and Lorentz vectors, especially arrays of vectors, to solve common physics problems in a NumPy-like way";
    homepage = "https://github.com/scikit-hep/vector";
    changelog = "https://github.com/scikit-hep/vector/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
