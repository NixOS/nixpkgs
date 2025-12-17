{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tencentcloud-sdk-python";
  version = "3.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TencentCloud";
    repo = "tencentcloud-sdk-python";
    tag = version;
    hash = "sha256-FGRoef5KloVuBlgBF2t4fyo1+cP5865oOrBZRoy2kQg=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tencentcloud" ];

  enabledTestPaths = [ "tests/unit/" ];

  disabledTests = [
    # KeyError
    "test_sts_credential_with_default_endpoint"
    "test_sts_credential_with_set_endpoint"
  ];

  meta = {
    description = "Tencent Cloud API 3.0 SDK for Python";
    homepage = "https://github.com/TencentCloud/tencentcloud-sdk-python";
    changelog = "https://github.com/TencentCloud/tencentcloud-sdk-python/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
