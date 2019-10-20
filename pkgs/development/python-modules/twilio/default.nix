{ stdenv, buildPythonPackage, fetchFromGitHub
, pyjwt, pysocks, pytz, requests, six, nose, mock }:

buildPythonPackage rec {
  pname = "twilio";
  version = "6.29.3";
  # tests not included in PyPi, so fetch from github instead
  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = version;
    sha256 = "0xc0lw6js8icshjh65rvgbnxrscqsd7ls3h0ni4xqg0kin9wyz42";
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
