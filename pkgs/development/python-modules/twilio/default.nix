{ lib
<<<<<<< HEAD
, aiohttp
, aiohttp-retry
, aiounittest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, cryptography
, django
, fetchFromGitHub
, mock
, multidict
<<<<<<< HEAD
, pyngrok
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyjwt
, pytestCheckHook
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "twilio";
<<<<<<< HEAD
  version = "8.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "7.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "twilio";
    repo = "twilio-python";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-fWAVTaie+6lz5cX7hg0s22kHXelIfhh5FNTfxxbUEPw=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiohttp-retry
    pyjwt
    pyngrok
=======
    hash = "sha256-14agJq7+fuQXqFDS8qfCj45XW/v3CekKmC5TA/5+eTk=";
  };

  propagatedBuildInputs = [
    pyjwt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytz
    requests
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    aiounittest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  disabledTestPaths = [
    # Tests require API token
    "tests/cluster/test_webhook.py"
    "tests/cluster/test_cluster.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
