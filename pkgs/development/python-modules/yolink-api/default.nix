{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  setuptools,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "yolink-api";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = "yolink-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8gzVaBne79t2Muen9QuYg8/tKwxWwDWBS98IopxiWn0=";
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

  meta = {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/YoSmart-Inc/yolink-api";
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
