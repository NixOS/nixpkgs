{ lib
, aiohttp
, aiohttp-retry
, aiounittest
, buildPythonPackage
, cryptography
, django
, fetchFromGitHub
, mock
, multidict
, pyngrok
, pyjwt
, pytestCheckHook
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "8.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = "refs/tags/${version}";
    hash = "sha256-UXQMDP5JjxTnHpvw730Yz0U8/CwYdRz3R64TP0Zgbcw=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiohttp-retry
    pyjwt
    pyngrok
    pytz
    requests
  ];

  nativeCheckInputs = [
    aiounittest
    cryptography
    django
    mock
    multidict
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_set_default_user_agent"
    "test_set_user_agent_extensions"
  ];

  disabledTestPaths = [
    # Tests require API token
    "tests/cluster/test_webhook.py"
    "tests/cluster/test_cluster.py"
  ];

  pythonImportsCheck = [
    "twilio"
  ];

  meta = with lib; {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    changelog = "https://github.com/twilio/twilio-python/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
