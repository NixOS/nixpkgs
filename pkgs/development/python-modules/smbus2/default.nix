{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytestCheckHook
=======
, nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "smbus2";
<<<<<<< HEAD
  version = "0.4.3";
  format = "setuptools";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-tjJurJzDn0ATiYY3Xo66lwUs98/7ZLG3d4+h1prVHAI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

=======
    hash = "sha256-6JzFbhUq8XR1nYkadPeYqItcLZDIFAwTe3BriEW2nVI=";
  };

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "smbus2"
  ];

  meta = with lib; {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/kplindegaard/smbus2/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
