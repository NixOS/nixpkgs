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
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8WH83K/1SbzjlAmjKVh3gT9KVvQ6BMRmg3Z0SSeL1j8=";
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
    changelog = "https://github.com/stanfordnlp/stanza/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ riotbib ];
  };
}
