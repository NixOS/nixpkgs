{
  lib,
  aiohttp-retry,
  aiohttp,
  aiounittest,
  buildPythonPackage,
  cryptography,
  django,
  fetchFromGitHub,
  mock,
  multidict,
  pyjwt,
  pyngrok,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "twilio";
  version = "9.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = "refs/tags/${version}";
    hash = "sha256-sZhKFnCmARocnOqM1NE6eGU/6UtfJSQTK+bv5HHHU1U=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  disabledTestPaths =
    [
      # Tests require API token
      "tests/cluster/test_webhook.py"
      "tests/cluster/test_cluster.py"
    ]
    ++ lib.optionals (pythonAtLeast "3.11") [
      # aiounittest is not supported on Python 3.12
      "tests/unit/http/test_async_http_client.py"
    ];

  pythonImportsCheck = [ "twilio" ];

  meta = with lib; {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    changelog = "https://github.com/twilio/twilio-python/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
