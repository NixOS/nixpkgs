{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python-socks
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.2.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1315816c0acc508997eb3ae03b9d3ff619c9d12d544c9a9b553704b1cc4f6af5";
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
