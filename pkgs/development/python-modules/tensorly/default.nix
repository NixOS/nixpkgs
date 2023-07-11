{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "tensorly";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hwpdExW/ESOavFkL3old1Efo5WC+PYmcgJp5/oLelaA=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tensorly"
    "tensorly.base"
    "tensorly.cp_tensor"
    "tensorly.tucker_tensor"
    "tensorly.tt_tensor"
    "tensorly.tt_matrix"
    "tensorly.parafac2_tensor"
    "tensorly.tenalg"
    "tensorly.decomposition"
    "tensorly.regression"
    "tensorly.metrics"
    "tensorly.random"
    "tensorly.datasets"
    "tensorly.plugins"
    "tensorly.contrib"
  ];

  pytestFlagsArray = [
    "tensorly"
  ];

  disabledTests = [
    # this can fail on hydra and other peoples machines, check with others before re-enabling
    # AssertionError: Partial_SVD took too long, maybe full_matrices set wrongly
    "test_svd_time"
  ];

  meta = with lib; {
    description = "Tensor learning in Python";
    homepage = "https://tensorly.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
