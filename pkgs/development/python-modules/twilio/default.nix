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
  version = "7.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-gN9cVBhiO34uj2ZGqXrnlvOlSaGxry0tMxaTK4SYhjM=";
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
