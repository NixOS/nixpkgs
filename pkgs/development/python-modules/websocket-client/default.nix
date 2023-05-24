{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, python-socks
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x9Z8E7koZF8lnZuEerW1f9LRJyE8pB69iA3h9VO3wjs=";
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
