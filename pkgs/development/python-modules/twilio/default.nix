{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pyjwt
, pysocks
, pytz
, requests
, six
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "6.56.0";


  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-vVJuuPxVyOqnplPYrjCjIm5IyIFZvsCMoDLrrHpHK+4=";
  };

  propagatedBuildInputs = [
    pyjwt
    pysocks
    pytz
    requests
    six
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
