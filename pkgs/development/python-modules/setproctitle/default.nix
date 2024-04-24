{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yRPhUefqAVZ4N/8DeiPKh0AZKIAZi3+7kLFtGBYHyq4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tries to compile programs with dependencies that aren't available
  disabledTestPaths = [
    "tests/setproctitle_test.py"
  ];

  meta = with lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  "https://github.com/dvarrazzo/py-setproctitle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
