{ lib
<<<<<<< HEAD
, async-timeout
, buildPythonPackage
, fetchFromGitLab
, flit-core
=======
, buildPythonPackage
, fetchFromGitLab
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, future
, ifaddr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yeelight";
<<<<<<< HEAD
  version = "0.7.13";
  format = "pyproject";
=======
  version = "0.7.10";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-IhEvyWgOTAlfQH1MX7GCpaJUJOGY/ZNbyk5Q6CiTDLA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    future
    ifaddr
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
=======
    rev = "v${version}";
    hash = "sha256-vUsL1CvhYRtv75gkmiPe/UkAtBDZPy1iK2BPUupMXz8=";
  };

  propagatedBuildInputs = [
    future
    ifaddr
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "yeelight/tests.py"
  ];

  pythonImportsCheck = [
    "yeelight"
  ];

  meta = with lib; {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
<<<<<<< HEAD
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
