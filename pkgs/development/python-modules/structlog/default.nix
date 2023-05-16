{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, pythonOlder
, pytestCheckHook
, pytest-asyncio
, pretend
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, freezegun
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
<<<<<<< HEAD
, pretend
, pytest-asyncio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, simplejson
, typing-extensions
=======
, simplejson
, typing-extensions
, pythonAtLeast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "structlog";
<<<<<<< HEAD
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "22.3.0";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-0zHvBMiZB4cGntdYXA7C9V9+FfnDB6sHGuFRYAo/LJw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

=======
    hash = "sha256-+r+M+uTXdNBWQf0TGQuZgsCXg2CBKwH8ZE2+uAe0Dzg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

<<<<<<< HEAD
=======
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

<<<<<<< HEAD
=======
  pythonImportsCheck = [
    "structlog"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    freezegun
    pretend
    pytest-asyncio
    pytestCheckHook
    simplejson
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "structlog"
  ];

  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    changelog = "https://github.com/hynek/structlog/blob/${version}/CHANGELOG.md";
=======
  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
