{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  numpy,
  llvmPackages,
  wurlitzer,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wasserstein";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pkomiske";
    repo = "Wasserstein";
    rev = "v${version}";
    hash = "sha256-s9en6XwvO/WPsF7/+SEmGePHZQgl7zLgu5sEn4nD9YE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/thaler-lab/Wasserstein/commit/8667d59dfdf89eabf01f3ae93b23a30a27c21c58.patch";
      hash = "sha256-jp5updB3E1MYgLhBJwmBMTwBiFXtABMwTxt0G6xhoyA=";
    })
  ];

  buildInputs = [ llvmPackages.openmp ];
  propagatedBuildInputs = [
    numpy
    wurlitzer
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "wasserstein/tests" ];
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
