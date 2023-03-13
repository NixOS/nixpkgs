{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "upcloud-api";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-python-api";
    rev = "v${version}";
    sha256 = "1kkgrn97pw4k49ys97hjrvh2j8y2p2r9970v9csgrk5wci4562wm";
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
