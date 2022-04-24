{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, h11
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "1.1.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ouVr/Vx82DwTadg7X+zNbTd5i3SHKGbmJhbg7PERvag=";
  };

  propagatedBuildInputs = [ h11 ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wsproto" ];

  meta = with lib; {
    description = "Pure Python, pure state-machine WebSocket implementation";
    homepage = "https://github.com/python-hyper/wsproto/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
