{ lib
, buildPythonPackage
, cython
<<<<<<< HEAD
, fetchpatch
, fetchPypi
, matplotlib
, numpy
, oldest-supported-numpy
=======
, fetchPypi
, matplotlib
, numpy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pandas
, patsy
, pythonOlder
, scipy
, setuptools-scm
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "statsmodels";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.13.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-aHXH1onpZtlI8V64FqtWFvSShwaxgM9HD9WQerb2R6Q=";
  };

  patches = [
    # https://github.com/statsmodels/statsmodels/pull/8969
    (fetchpatch {
      name = "unpin-setuptools-scm.patch";
      url = "https://github.com/statsmodels/statsmodels/commit/cfad8d81166e9b1392ba99763b95983afdb6d61b.patch";
      hash = "sha256-l7cQHodkPm399a+3qIVmXPk/Ca+CqJDyWXWgjb062nM=";
    })
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools-scm
    wheel
=======
    hash = "sha256-WTUmrK4cD9oOpsSEOfZ8OUMJTFQv52n4uQ/p5sbMSHE=";
  };

  nativeBuildInputs = [
    cython
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
    patsy
    matplotlib
  ];

  # Huge test suites with several test failures
  doCheck = false;

  pythonImportsCheck = [
    "statsmodels"
  ];

  meta = with lib; {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    changelog = "https://github.com/statsmodels/statsmodels/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
