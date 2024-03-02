{ lib
, buildPythonPackage
, emoji
, fetchFromGitHub
, networkx
, numpy
, peft
, protobuf
, pythonOlder
, requests
, six
, toml
, torch
, tqdm
, transformers
}:

buildPythonPackage rec {
  pname = "stanza";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uLstqplCQ55fW5WRS1qSrE6sGgpc8z92gyoksUnGpnQ=";
  };

  propagatedBuildInputs = [
    emoji
    networkx
    numpy
    peft
    protobuf
    requests
    six
    toml
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
