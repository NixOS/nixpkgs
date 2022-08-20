{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.2.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7PKLHAenmddvQyblCBV7ca7aB7hLkDaOpFHAcQ29MsA=";
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
