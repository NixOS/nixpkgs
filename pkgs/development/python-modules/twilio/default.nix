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
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "twilio";
  version = "9.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    tag = finalAttrs.version;
    hash = "sha256-0y0WCH0d25P8FD0pbmzgZG8zX05HFziu2vNVawWE38g=";
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

  disabledTestPaths = [
    # Tests require API token
    "tests/cluster/test_webhook.py"
    "tests/cluster/test_cluster.py"
  ];

  pythonImportsCheck = [ "twilio" ];

  meta = {
    description = "Twilio API client and TwiML generator";
    homepage = "https://github.com/twilio/twilio-python/";
    changelog = "https://github.com/twilio/twilio-python/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
