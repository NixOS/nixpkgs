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
  version = "0.38.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-mqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-oDf/W8EiU9vg64/FDryp8NEMyDT7lI5nlkxiCAg88pY=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    python-dateutil
    weconnect
  ];

  postPatch = ''
    substituteInPlace weconnect_mqtt/__version.py \
      --replace "develop" "${version}"
    substituteInPlace pytest.ini \
      --replace "--cov=weconnect_mqtt --cov-config=.coveragerc --cov-report html" "" \
      --replace "pytest-cov" ""
    substituteInPlace requirements.txt \
      --replace "weconnect[Images]~=0.40.0" "weconnect"
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
