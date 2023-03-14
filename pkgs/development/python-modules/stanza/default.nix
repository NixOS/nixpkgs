{ lib
, buildPythonPackage
, emoji
, fetchFromGitHub
, numpy
, protobuf
, pythonOlder
, requests
, six
, torch
, tqdm
, transformers
}:

buildPythonPackage rec {
  pname = "stanza";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-v4/wYfXqOwSXxx864LNxviRtsqu5DXqs9diswA1oZXc=";
  };

  propagatedBuildInputs = [
    emoji
    numpy
    protobuf
    requests
    six
    torch
    tqdm
    transformers
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "stanza"
  ];

  meta = with lib; {
    description = "Official Stanford NLP Python Library for Many Human Languages";
    homepage = "https://github.com/stanfordnlp/stanza/";
    license = licenses.asl20;
    maintainers = with maintainers; [ riotbib ];
  };
}
