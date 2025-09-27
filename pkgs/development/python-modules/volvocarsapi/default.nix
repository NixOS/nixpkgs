{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiohttp,
  yarl,
  hatchling,
}:

buildPythonPackage rec {
  pname = "volvocarsapi";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "volvo-cars-api";
    tag = "v${version}";
    hash = "sha256-mVr9bhWK4VWFnR6yfNVFYGMKRSv4XrYP2Wb3nlnDZ+E=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    aiohttp
    yarl
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [
    "volvocarsapi"
  ];

  meta = {
    description = "Python client for the Volvo Cars API";
    homepage = "https://github.com/thomasddn/volvo-cars-api";
    changelog = "https://github.com/thomasddn/volvo-cars-api/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
