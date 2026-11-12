{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  aiohttp,
  yarl,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "volvocarsapi";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "volvo-cars-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KxDgtGe7SrrYdj+dT4/C/xH85mkih9PDzFxj6QqFleU=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "volvocarsapi" ];

  meta = {
    description = "Python client for the Volvo Cars API";
    homepage = "https://github.com/thomasddn/volvo-cars-api";
    changelog = "https://github.com/thomasddn/volvo-cars-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
