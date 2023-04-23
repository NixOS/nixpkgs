{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, llvmPackages
, wurlitzer
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wasserstein";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pkomiske";
    repo = "Wasserstein";
    rev = "89c2d6279a7e0aa3b56bcc8fb7b6009420f2563e"; # https://github.com/pkomiske/Wasserstein/issues/1
    hash = "sha256-s9en6XwvO/WPsF7/+SEmGePHZQgl7zLgu5sEn4nD9YE=";
  };

  buildInputs = [
    llvmPackages.openmp
  ];
  propagatedBuildInputs = [
    numpy
    wurlitzer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [
    "wasserstein/tests"
  ];
  disabledTestPaths = [
    "wasserstein/tests/test_emd.py" # requires "ot"
    # cyclic dependency on energyflow
    "wasserstein/tests/test_externalemdhandler.py"
    "wasserstein/tests/test_pairwiseemd.py"
  ];

  pythonImportsCheck = [ "wasserstein" ];

  meta = with lib; {
    description = "Python/C++ library for computing Wasserstein distances efficiently";
    homepage = "https://github.com/pkomiske/Wasserstein";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
  };
}
