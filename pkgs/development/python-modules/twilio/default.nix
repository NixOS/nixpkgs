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
  version = "9.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    tag = finalAttrs.version;
    hash = "sha256-DJxyDnAv3wKcujBFCE808PJ9NZe/PN8+Z9J2o49n0HU=";
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
