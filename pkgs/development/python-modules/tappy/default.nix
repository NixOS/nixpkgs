{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tap.py";
  version = "3.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9e7u6/1k5T0yZhdSu0wohYmjuru5bbPzkaTsKfE1nHA=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tap" ];

  meta = with lib; {
    homepage = "https://github.com/python-tap/tappy";
    description = "A set of tools for working with the Test Anything Protocol (TAP) in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sfrijters ];
  };
}
