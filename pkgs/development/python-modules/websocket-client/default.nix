{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-socks,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "websocket-client";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "websocket-client";
    repo = "websocket-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yqB+8PdMDixKYegLiaU/fYbYmpOcnvH/CFEYZTG9gUQ=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    optional = [
      python-socks
      # wsaccel is not available at the moment
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    "websocket/tests"
  ];

  pythonImportsCheck = [ "websocket" ];

  meta = {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wsdump";
  };
})
