{ lib
, fetchFromGitHub
, buildPythonPackage
, authlib
, requests
, nose
, pythonOlder
, pytz
, responses
, zeep
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "1.11.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/uaFEQnilcelHKjbmrnyLm5Mzj2V8P4oEH+cgJn+KvI=";
  };

  propagatedBuildInputs = [
    authlib
    requests
    zeep
  ];

  checkInputs = [
    nose
    pytz
    responses
  ];

  checkPhase = ''
    runHook preCheck
    nosetests -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };

}
