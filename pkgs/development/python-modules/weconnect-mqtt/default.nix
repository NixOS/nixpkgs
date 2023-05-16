{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, paho-mqtt
, python-dateutil
, weconnect
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
<<<<<<< HEAD
  version = "0.46.0";
=======
  version = "0.42.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-7TR6+woAV8f80t4epCnZj4jYYpTPKDkzwzNNsgofiwg=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "weconnect[Images]~=" "weconnect>="
=======
    hash = "sha256-TEB2UtXH73CCJhbuQjnABcG3XLHB6VybDwjhixnpt0w=";
  };

  postPatch = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace weconnect_mqtt/__version.py \
      --replace "develop" "${version}"
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect_mqtt --cov-config=.coveragerc --cov-report html" "" \
      --replace "pytest-cov" ""
  '';

  propagatedBuildInputs = [
    paho-mqtt
    python-dateutil
    weconnect
  ] ++ weconnect.optional-dependencies.Images;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "weconnect_mqtt"
  ];

  meta = with lib; {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    changelog = "https://github.com/tillsteinbach/WeConnect-mqtt/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
