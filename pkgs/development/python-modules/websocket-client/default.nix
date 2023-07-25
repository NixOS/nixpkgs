{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python-socks
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pwnm2CMIklRxMhd/V1pOPnPP3wZSbiDMAqocO0cYTUA=";
  };

  propagatedBuildInputs = [
    python-socks
   ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "websocket"
  ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
