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
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = "yolink-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-VJqKORyAlTBIRsHaeUrLDuvVAU/EX/Zzh8u7xxmD2IE=";
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
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
