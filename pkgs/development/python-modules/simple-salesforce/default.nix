{ lib
, fetchFromGitHub
, buildPythonPackage
, authlib
, requests
, nose
, pyjwt
, pythonOlder
, pytz
, responses
, zeep
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "1.12.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mj7lbBGEybsEzWo4TYmPrN3mBXItdo/JomVIYmzIDAY=";
  };

  propagatedBuildInputs = [
    authlib
    pyjwt
    requests
    zeep
  ];

  nativeCheckInputs = [
    nose
    pytz
    responses
  ];

  checkPhase = ''
    runHook preCheck
    nosetests -v
    runHook postCheck
  '';

  pythonImportsCheck = [
    "simple_salesforce"
  ];

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    changelog = "https://github.com/simple-salesforce/simple-salesforce/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
