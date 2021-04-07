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
  version = "6.51.1";

  # tests not included in PyPi, so fetch from github instead
  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "sha256-OHtmUFm/9GkpIzz0DdSdlHyBFRIgu8GxQ4S4VMJik9o=";
  };

  buildInputs = [ nose mock ];

  propagatedBuildInputs = [ pyjwt pysocks pytz six requests ];

  pythonImportsCheck = [ "twilio" ];

  meta = with lib; {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
