{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, emoji
, numpy
, protobuf
, requests
, six
, pytorch
, tqdm
}:

buildPythonPackage rec {
  pname = "stanza";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-EAES3UpJqE7wmvCPycFhwI1lMrReN+L6W8CEDwdHTlA=";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    emoji
    numpy
    protobuf
    requests
    six
    pytorch
    tqdm
  ];

  # disabled, because the tests try to connect to the internet which
  # is forbidden in the sandbox
  doCheck = false;

  pythonImportsCheck = [ "stanza" ];

  meta = with lib; {
    description = "Official Stanford NLP Python Library for Many Human Languages";
    homepage = "https://github.com/stanfordnlp/stanza/";
    license = licenses.asl20;
    maintainers = with maintainers; [ riotbib ];
  };
}
