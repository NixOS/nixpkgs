{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttls";
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = "ttls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RmfaDVpficgeQVy+mdlUhM8foUUyW/Z17IZmteYpFmo=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ttls" ];

  meta = {
    description = "Module to interact with Twinkly LEDs";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ttls";
  };
})
