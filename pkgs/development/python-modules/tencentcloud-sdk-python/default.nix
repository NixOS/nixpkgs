{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tencentcloud-sdk-python";
  version = "3.0.1370";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "TencentCloud";
    repo = "tencentcloud-sdk-python";
    tag = version;
    hash = "sha256-o0X1liAHKIGQEymmSU25rGu+HPSzJiPgx+tk4LlIl8Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tencentcloud" ];

  pytestFlagsArray = [ "tests/unit/" ];

  meta = with lib; {
    description = "Tencent Cloud API 3.0 SDK for Python";
    homepage = "https://github.com/TencentCloud/tencentcloud-sdk-python";
    changelog = "https://github.com/TencentCloud/tencentcloud-sdk-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
