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
  version = "1.12.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-lCZdX+gf9ROU1MIRw/ppTNO8jIGUxE1+gbHh6sK5L2s=";
  };

  propagatedBuildInputs = [
    authlib
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

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };

}
