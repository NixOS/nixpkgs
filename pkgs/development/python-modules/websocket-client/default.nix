{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-socks,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "websocket_client";
    inherit version;
    hash = "sha256-Mjnfn0TaYy+WASRygF1AojKBqZECfOEdL0Wm8krEw9o=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    optional = [
      python-socks
      # wsaccel is not available at the moment
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "websocket" ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "wsdump";
  };
}
