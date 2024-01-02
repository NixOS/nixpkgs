{ lib
, buildPythonPackage
, fetchFromGitHub
, pexpect
, pillow
, pycryptodomex
, pytestCheckHook
, pythonOlder
, pyvirtualdisplay
, setuptools
, twisted
}:

buildPythonPackage rec {
  pname = "vncdo";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    rev = "refs/tags/v${version}";
    hash = "sha256-m8msWa8uUuDEjEUlXHCgYi0HFPKXLVXpXLyuQ3quNbA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pillow
    pycryptodomex
    twisted
  ];

  nativeCheckInputs = [
    pexpect
    pytestCheckHook
    pyvirtualdisplay
  ];

  pythonImportsCheck = [
    "vncdotool"
  ];

  meta = with lib; {
    description = "A command line VNC client and Python library";
    homepage = "https://github.com/sibson/vncdotool";
    changelog = "https://github.com/sibson/vncdotool/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
    mainProgram = "vncdo";
    platforms = with platforms; linux ++ darwin;
  };
}
