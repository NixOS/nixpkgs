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
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1xysym0b1qnxck4hbj5d0l5wapwfahmkr280f6iskz2hi5j2j1yb";
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
