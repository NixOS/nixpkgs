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
  setuptools,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.15.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tweepy";
    repo = "tweepy";
    tag = "v${version}";
    hash = "sha256-vbiMwaJh4cN7OY7eYu2s8azs3A0KXvW/kRPVCx50ZVA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    oauthlib
    requests
    requests-oauthlib
  ];

  optional-dependencies = {
    async = [
      aiohttp
      async-lru
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
