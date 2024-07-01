{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "upcloud-api";
  version = "2.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-fMsI0aZ8jA08rrNPm8HmfYz/a3HLUExvvXIeDGPh2e8=";
  };

  propagatedBuildInputs = [ requests ];

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
