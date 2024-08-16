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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-RDGRue9hejNPKIP61GtJHMG5rG3CKvJdsYxVrp6I5W0=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "upcloud_api" ];

  meta = with lib; {
    changelog = "https://github.com/UpCloudLtd/upcloud-python-api/blob/${src.rev}/CHANGELOG.md";
    description = "UpCloud API Client";
    homepage = "https://github.com/UpCloudLtd/upcloud-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
