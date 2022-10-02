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
  version = "0.40.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-WnaVE9WEJmdlxsPUZcEmeCf4DK1GCyd2yQmBiQZ7NkI=";
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
