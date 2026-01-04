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
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = "yolink-api";
    tag = "v${version}";
    hash = "sha256-ayNSYIhNqSqMH9OJ8pyFDQWuIBkv4tda+eOWEGOn2Pk=";
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
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
