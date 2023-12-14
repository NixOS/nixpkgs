{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ufuXkHyDDSYPoGWO1Yr9SKhrK4iqxSETXDUv9/00d/0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # tries to compile programs with dependencies that aren't available
  pytestFlagsArray = [ "--ignore=tests/setproctitle_test.py" ];

  meta = with lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  "https://github.com/dvarrazzo/py-setproctitle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
