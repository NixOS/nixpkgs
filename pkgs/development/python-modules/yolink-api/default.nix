{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pydantic
, pythonOlder
, tenacity
}:

buildPythonPackage rec {
  pname = "yolink-api";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zkZpP5X5D9BkR5ny43tJsjBRhF6XZ6Q2VvOiI+QUcfA=";
  };

  propagatedBuildInputs = [
    aiohttp
    paho-mqtt
    pydantic
    tenacity
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "yolink"
  ];

  meta = with lib; {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/YoSmart-Inc/yolink-api";
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
