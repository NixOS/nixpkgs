{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, pyjwt
, pytz
, requests

, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "7.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-PxLDAP/6Ddvf58eEyX3DHkdBNuLE5DlLdCEaRguqOy0=";
  };

  propagatedBuildInputs = [
    pyjwt
    pytz
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
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
