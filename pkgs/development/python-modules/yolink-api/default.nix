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

buildPythonPackage rec {
  pname = "yolink-api";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = "yolink-api";
    tag = "v${version}";
    hash = "sha256-NViXbi5s4Ht2b8hpsumnlbstjiR/MWz2El39xk3uqb4=";
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
