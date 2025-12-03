{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  keyring,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "upcloud-api";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    tag = "v${version}";
    hash = "sha256-OnHKKSlj6JbqXL1YDkmR7d6ae8eVdXOPx6Los5qPDJE=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  optional-dependencies = {
    keyring = [ keyring ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "upcloud_api" ];

  meta = with lib; {
    changelog = "https://github.com/UpCloudLtd/upcloud-python-api/blob/${src.tag}/CHANGELOG.md";
    description = "UpCloud API Client";
    homepage = "https://github.com/UpCloudLtd/upcloud-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
