{ stdenv, buildPythonPackage, fetchFromGitHub
, pyjwt, pysocks, pytz, requests, six, nose, mock }:

buildPythonPackage rec {
  pname = "twilio";
  version = "6.23.1";
  # tests not included in PyPi, so fetch from github instead
  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "0f6r2qcgcg4pnnsgf9d1k03ri7h7k8kpasp9mdgv421a4rvqh8lm";
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
