{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df";
  };

  checkInputs = [ pytestCheckHook ];

  # tries to compile programs with dependencies that aren't available
  pytestFlagsArray = [ "--ignore=tests/setproctitle_test.py" ];

  meta = with lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  "https://github.com/dvarrazzo/py-setproctitle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
