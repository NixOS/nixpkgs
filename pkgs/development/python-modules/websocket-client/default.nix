{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-socks,
  setuptools,
}:

buildPythonPackage rec {
  pname = "websocket-client";
  version = "1.8.0";
  pyproject = true;

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

  meta = {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wsdump";
  };
}
