{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, sphinx
, pyenchant
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
, pbr
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "8.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GZ0KFpAq2Aw4fClm3J6xD1ZbH7FczOFyEEAtt8JEPlw=";
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    setuptools
    setuptools-scm
    wheel
=======
    pbr
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    sphinx
    pyenchant
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.spelling"
  ];

  meta = with lib; {
    description = "Sphinx spelling extension";
    homepage = "https://github.com/sphinx-contrib/spelling";
    changelog = "https://github.com/sphinx-contrib/spelling/blob/${version}/docs/source/history.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
