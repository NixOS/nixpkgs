{ lib
, aiohttp
, async-lru
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, six
, vcrpy
}:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-D/cArsGzWr+rCC9iW9qOfc5fT7UKZDupeR/rQMNK5I4=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-lru
    oauthlib
    requests
    requests-oauthlib
    six
  ];

  checkInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "tweepy"
  ];

  meta = with lib; {
    description = "Twitter library for Python";
    homepage = "https://github.com/tweepy/tweepy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
