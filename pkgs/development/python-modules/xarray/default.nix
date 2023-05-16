{ lib
, buildPythonPackage
, fetchPypi
, numpy
, packaging
, pandas
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
, setuptoolsBuildHook
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "xarray";
<<<<<<< HEAD
  version = "2023.7.0";
=======
  version = "2023.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-2s4v2/G3/xhdnBImokv4PCrlLzJT2/6A4X0RYmANBVw=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
=======
    hash = "sha256-qnYFAKLY+L6O/Y87J6lLKvOwqMLANzR9WV6vb/Cdinc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION="${version}";

  nativeBuildInputs = [
    setuptoolsBuildHook
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xarray"
  ];

  meta = with lib; {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = licenses.asl20;
    maintainers = with maintainers; [ fridh ];
  };
}
