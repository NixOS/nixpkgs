{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pyjwt
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "7.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "0h6r9nz7dcvagrjhzvnirpnjazcy9r64cwlr2bnmlrbjhwdni9rq";
  };

  propagatedBuildInputs = [
    pyjwt
    pytz
    requests
  ];

  checkInputs = [
    mock
    nose
  ];

  pythonImportsCheck = [
    "twilio"
  ];

  meta = with lib; {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
