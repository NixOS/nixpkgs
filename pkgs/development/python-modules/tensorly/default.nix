{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, sparse
}:

buildPythonPackage rec {
  pname = "tensorly";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-VcX3pCczZQUYZaD7xrrkOcj0QPJt28cYTwpZm5D/X3c=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    sparse
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # nose is not actually required for anything
    # (including testing with the minimal dependencies)
    substituteInPlace setup.py \
      --replace ", 'nose'" ""
  '';

  pythonImportsCheck = [
    "tensorly"
  ];

  pytestFlagsArray = [
    "tensorly"
  ];

  disabledTests = [
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
