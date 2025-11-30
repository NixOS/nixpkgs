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
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TencentCloud";
    repo = "tencentcloud-sdk-python";
    tag = version;
    hash = "sha256-tNNIHO89Yda8mjqdOxhA/QI8D6veOM1xVO/LoSVEB70=";
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

  meta = with lib; {
    description = "Tencent Cloud API 3.0 SDK for Python";
    homepage = "https://github.com/TencentCloud/tencentcloud-sdk-python";
    changelog = "https://github.com/TencentCloud/tencentcloud-sdk-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
