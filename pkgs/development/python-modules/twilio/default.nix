{ stdenv, buildPythonPackage, fetchFromGitHub
, pyjwt, pysocks, pytz, requests, six, nose, mock }:

buildPythonPackage rec {
  pname = "twilio";
  version = "6.26.1";
  # tests not included in PyPi, so fetch from github instead
  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "1ly22ah487jkq0my1l3c6hbx24fgganjhxrlrcw5jfc80qmgd3hd";
  };

  buildInputs = [ nose mock ];

  propagatedBuildInputs = [ pyjwt pysocks pytz six requests ];

  meta = with stdenv.lib; {
    description = "Twilio API client and TwiML generator";
    homepage = https://github.com/twilio/twilio-python/;
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
