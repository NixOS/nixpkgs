{ lib
, fetchFromGitHub
, buildPythonPackage
, authlib
, requests
, mock
, isPy27
, nose
, pytz
, responses
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "16c34xnqa1xkdfjbxx0q584zb6aqci2z6j4211hmzjqs74ddvysm";
  };

  propagatedBuildInputs = [
    authlib
    requests
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
