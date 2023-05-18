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
  version = "0.2.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DbdoGNwz7HtscnDv+rOI2zcs4i4Dl1DpRZNH/DOcJHc=";
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
