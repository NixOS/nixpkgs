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
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "17d6g7zfhlgd2n4mimjarl2x4hl7ww2lb4izidlns1hzqm8igg4y";
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
