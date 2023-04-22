{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, h11
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "1.2.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rVZfJuy5JYij5DvD2WFk3oTNmQJIKxMNDduqlmSoUGU=";
  };

  propagatedBuildInputs = [ h11 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wsproto" ];

  meta = with lib; {
    description = "Pure Python, pure state-machine WebSocket implementation";
    homepage = "https://github.com/python-hyper/wsproto/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
