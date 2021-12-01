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
  version = "7.2.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-lhRlLZ9RpOpNIPEgrO7+JO8CnqeC3gqgGqXjznsA9ls=";
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
