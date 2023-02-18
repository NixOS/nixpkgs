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
  version = "0.42.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-jxfV2RDyGLugnPae+uNtg/GBsWbKCSbKxuHll10guhU=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    python-dateutil
    weconnect
  ] ++ weconnect.optional-dependencies.Images;

  postPatch = ''
    substituteInPlace weconnect_mqtt/__version.py \
      --replace "develop" "${version}"
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect_mqtt --cov-config=.coveragerc --cov-report html" "" \
      --replace "pytest-cov" ""
  '';

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
