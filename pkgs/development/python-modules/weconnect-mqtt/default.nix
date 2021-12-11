{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, paho-mqtt
, weconnect
}:

buildPythonPackage rec {
  pname = "weconnect-mqtt";
  version = "0.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "v${version}";
    sha256 = "sha256-RUOOHVX9IY24ZpDE7nQr//JxtQZgowcT5PrTgzaTK6Q=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    weconnect
  ];

  postPatch = ''
    substituteInPlace weconnect_mqtt/__version.py \
      --replace "develop" "${version}"
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect_mqtt --cov-config=.coveragerc --cov-report html" "" \
      --replace "pytest-cov" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "weconnect_mqtt"
  ];

  meta = with lib; {
    description = "Python client that publishes data from Volkswagen WeConnect";
    homepage = "https://github.com/tillsteinbach/WeConnect-mqtt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
