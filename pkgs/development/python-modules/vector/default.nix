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
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "vector";
    tag = "v${version}";
    hash = "sha256-KwxQ2sA8cdHmTRbh23H5iTexMlWK2MxdA8XWpXscpfU=";
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

  disabledTests = [
    # AssertionErrors in sympy tests
    "test_lorentz_object"
    "test_lorentz_sympy"
    "test_rhophi_eta_t"
    "test_rhophi_eta_tau"
    "test_xy_eta_t"
    "test_xy_eta_tau"

    # AssertionError: assert array([2.]) == array([-2.])
    "test_issue_443"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    # numba/typed/typeddict.py", line 185 in __setitem__
    "test_method_transform2D"
    "test_method_transform3D"
    "test_method_transform4D"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: assert 2.1073424255447017e-08 == 0.0
    "test_issue_463"
  ];

  meta = {
    description = "Library for 2D, 3D, and Lorentz vectors, especially arrays of vectors, to solve common physics problems in a NumPy-like way";
    homepage = "https://github.com/scikit-hep/vector";
    changelog = "https://github.com/scikit-hep/vector/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
