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
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-c7FaqI/8h6loLJJ9xOaJCyepWp+bc6IcqQlpGlW7u6g=";
=======
    hash = "sha256-sFGAVavY16UQNJmW467+Ekojws59UMcAoCc1t9wWHM4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
