{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pythonOlder,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "yolink-api";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = "yolink-api";
    tag = "v${version}";
    hash = "sha256-ZFEEFYCA5hBtQTe1G80wxIOF6sR+gbaqpjm9oqyyvE8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiomqtt
    pydantic
    tenacity
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "yolink" ];

  meta = with lib; {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/YoSmart-Inc/yolink-api";
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
