{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "websocket-client";
    repo = "websocket-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-rjhRZAzWbqzhyHIprHv/8thkdkBXax2dLXYoq3PyXlI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ python-socks ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "websocket" ];

  disabledTestPaths = [
    # ConnectionRefusedError: [Errno 111] Connection refused
    "compliance/test_fuzzingclient.py"
  ];

  meta = with lib; {
    description = "Websocket client for Python";
    homepage = "https://github.com/websocket-client/websocket-client";
    changelog = "https://github.com/websocket-client/websocket-client/blob/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "wsdump";
  };
}
