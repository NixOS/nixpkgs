{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybraendstofpriser";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pybraendstofpriser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qS3qO7dnGkcTe9s21Ob4K1LicW0cbqJchtVvPAB7PfM=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # The test script requires an API key and network access.
  doCheck = false;

  pythonImportsCheck = [ "pybraendstofpriser" ];

  meta = {
    description = "Library for fetching fuel prices from Fuelprices.dk API";
    homepage = "https://github.com/MTrab/pybraendstofpriser";
    changelog = "https://github.com/MTrab/pybraendstofpriser/releases/tag/${finalAttrs.src.tag}";
    # Awaiting license clarification from upstream.
    # https://github.com/MTrab/pybraendstofpriser/issues/44
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
