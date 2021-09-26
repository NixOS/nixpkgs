{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pyjwt
, pysocks
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "7.0.0";


  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-jowfUt0TWVmQzWbw6nkEiiAvExn7dkuXYJrZWAx9KRA=";
  };

  propagatedBuildInputs = [
    pyjwt
    pysocks
    pytz
    requests
  ];

  checkInputs = [
    mock
    nose
  ];

  pythonImportsCheck = [ "twilio" ];

  meta = with lib; {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
