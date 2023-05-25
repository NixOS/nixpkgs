{ stdenv, lib, buildPythonPackage, fetchPypi, pytestCheckHook, pyusb }:

buildPythonPackage rec {
  pname = "python-yubico";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gd3an1cdcq328nr1c9ijrsf32v0crv6dgq7knld8m9cadj517c7";
  };

  propagatedBuildInputs = [ pyusb ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "yubico" ];

  disabledTests = [
    "usb" # requires a physical yubikey to test
  ];

  meta = with lib; {
    description = "Python code to talk to YubiKeys";
    homepage    = "https://github.com/Yubico/python-yubico";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ s1341 ];
  };
}
