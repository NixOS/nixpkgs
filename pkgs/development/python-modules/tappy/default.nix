{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tap.py";
  version = "3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PAzUUhKtWiWzVEWWTiUX76AAoRihv8NDfa6CiJLq8eE=";
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
