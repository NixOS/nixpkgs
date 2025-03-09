{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O0DTKj4fBOlCMe1t/uDankO0+ca1RQ1T5t13VMNODFA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # tries to compile programs with dependencies that aren't available
  disabledTestPaths = [ "tests/setproctitle_test.py" ];

  meta = with lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage = "https://github.com/dvarrazzo/py-setproctitle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };
}
