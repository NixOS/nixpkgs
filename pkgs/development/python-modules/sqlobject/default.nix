{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, formencode
, pastedeploy
, paste
, pydispatcher
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlobject";
<<<<<<< HEAD
  version = "3.10.2";
=======
  version = "3.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLObject";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-dW9IsIdOSnCG3thWhYwIsz0Oa5runnXD84S5ITPH3ww=";
=======
    hash = "sha256-/PPqJ/ha8GRQpY/uQOLIF0v90p9tZKrHTCMkusiIuEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    formencode
    paste
    pastedeploy
    pydispatcher
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/sqlobject/sqlobject/issues/179
    "test_fail"
  ];

  pythonImportsCheck = [
    "sqlobject"
  ];

  meta = with lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
<<<<<<< HEAD
    changelog = "https://github.com/sqlobject/sqlobject/blob/${version}/docs/News.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
