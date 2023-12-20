{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python-socks
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.6.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-szJAGbPChXIIbEoxn5HR3NRObhHNNAIyl4xoSnZQ0N8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
