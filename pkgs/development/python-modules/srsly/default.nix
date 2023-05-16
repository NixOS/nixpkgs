{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, catalogue
, mock
, numpy
, psutil
, pytest
, ruamel-yaml
, setuptools
, tornado
}:

buildPythonPackage rec {
  pname = "srsly";
<<<<<<< HEAD
  version = "2.4.7";
=======
  version = "2.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-k8LMRYh3gmHMsj3QVDsk3tgQFd2KtOwTfNfQSWUDXQg=";
=======
    hash = "sha256-R7QfMjq6TJwzEav2DkQ8A6nv6cafZdxALRc8Mvd0Sm8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    catalogue
  ];

  nativeCheckInputs = [
    mock
    numpy
    psutil
    pytest
    ruamel-yaml
    tornado
  ];

  pythonImportsCheck = [
    "srsly"
  ];

  meta = with lib; {
    changelog = "https://github.com/explosion/srsly/releases/tag/v${version}";
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
  };
}
