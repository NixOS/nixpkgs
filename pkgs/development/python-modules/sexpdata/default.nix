{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sexpdata";
<<<<<<< HEAD
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b2XxFSkYkMvOXNJpwTvfH4KkzSO8YbbhUKJ1Ee5qfV4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [
    "sexpdata"
  ];

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/jd-boyd/sexpdata";
    changelog = "https://github.com/jd-boyd/sexpdata/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
=======
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6NX3XDeKB8bRzGH62WEbRRyTg8AlMFLhYZioUuFiBwU=";
  };

  doCheck = false;

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
