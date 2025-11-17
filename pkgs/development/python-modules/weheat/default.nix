{
  lib,
  aenum,
  aiohttp-retry,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "weheat";
  version = "2025.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wefabricate";
    repo = "wh-python";
    tag = version;
    hash = "sha256-CBW+LehZPZCHZ2zFeCOWwNAVlGcGdKQ5XgmCOv8jr5Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aenum
    aiohttp
    aiohttp-retry
    pydantic
    python-dateutil
    urllib3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "weheat" ];

  meta = {
    description = "Library to interact with the weheat API";
    homepage = "https://github.com/wefabricate/wh-python";
    changelog = "https://github.com/wefabricate/wh-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
