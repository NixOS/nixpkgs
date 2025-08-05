{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "upcloud-api";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    tag = "v${version}";
    hash = "sha256-YTccjuoagjS/Gllw8VtJ4NFoVqN1YeqXdgHI7BtP98w=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "upcloud_api" ];

  meta = with lib; {
    changelog = "https://github.com/UpCloudLtd/upcloud-python-api/blob/${src.tag}/CHANGELOG.md";
    description = "UpCloud API Client";
    homepage = "https://github.com/UpCloudLtd/upcloud-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
