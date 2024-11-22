{
  lib,
  aiohttp,
  async-lru,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-oauthlib,
  six,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ugqa85l0eWVtMUl5d+BjEWvTyH8c5NVtsnPflkHTWh8=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-lru
    oauthlib
    requests
    requests-oauthlib
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "tweepy" ];

  # The checks with streaming fail due to (seemingly) not decoding (or unexpectedly sending response in) GZIP
  # Same issue impacted mastodon-py, see https://github.com/halcy/Mastodon.py/commit/cd86887d88bbc07de462d1e00a8fbc3d956c0151 (who just disabled these)
  disabledTestPaths = [ "tests/test_client.py" ];

  disabledTests = [
    "test_indicate_direct_message_typing"
    "testcachedifferentqueryparameters"
    "testcachedresult"
    "testcreatedestroyblock"
    "testcreatedestroyfriendship"
    "testcreateupdatedestroylist"
    "testgetfollowerids"
    "testgetfollowers"
    "testgetfriendids"
    "testgetfriends"
    "testgetuser"
    "testcursorcursoritems"
    "testcursorcursorpages"
    "testcursornext"
  ];

  meta = with lib; {
    description = "Twitter library for Python";
    homepage = "https://github.com/tweepy/tweepy";
    changelog = "https://github.com/tweepy/tweepy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
