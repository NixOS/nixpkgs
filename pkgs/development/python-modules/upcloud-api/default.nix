{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "upcloud-api";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-thmrbCpGjlDkHIZwIjRgIVMplaypiKByFS/nS8F2LXA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "upcloud_api" ];

  meta = with lib; {
    description = "UpCloud API Client";
    homepage = "https://github.com/UpCloudLtd/upcloud-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
