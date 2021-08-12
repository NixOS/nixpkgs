{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python-socks
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dmW6bGRZibKLYWcIdKt1PmkpF56fyQVlrOasCQ9ZxVk=";
  };

  propagatedBuildInputs = [
    python-socks
   ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "websocket" ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
