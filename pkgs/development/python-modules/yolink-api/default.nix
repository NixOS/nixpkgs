{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pydantic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yolink-api";
  version = "0.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zdCHKckt28abeJ6PQjX50e/4wOl/xx0TKFEQaUIqrYo=";
  };

  propagatedBuildInputs = [
    aiohttp
    paho-mqtt
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "yolink"
  ];

  meta = with lib; {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/YoSmart-Inc/yolink-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
