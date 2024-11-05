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
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "vector";
    rev = "refs/tags/v${version}";
    hash = "sha256-lj6ZloBGZqHW0g7lCD7m9zvszJceB9TQ3r6B3Xuj5KE=";
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

  disabledTests =
    [
      # AssertionError (unclear why)
      "test_rhophi_eta_tau"
      "test_xy_eta_tau"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
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
