{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, asyncio-mqtt
, pydantic
, pythonOlder
, setuptools
, tenacity
}:

buildPythonPackage rec {
  pname = "yolink-api";
  version = "0.2.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dcuP2VPAp3Na1o9DV3bPejCrtaIxvt+g/vRaQYqI67Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    asyncio-mqtt
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
